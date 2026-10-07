#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
command -v git >/dev/null || fail 'Git is required.'
command -v python3 >/dev/null || fail 'Python 3 is required.'
git rev-parse --is-inside-work-tree >/dev/null
bash -n scripts/validate-repo.sh

# Include new, non-ignored files so validation also works before staging.
# Ignored deployment state is intentionally outside the publication boundary.
python3 - <<'PY'
import ipaddress
import pathlib
import re
import subprocess

files = subprocess.check_output(
    ['git', 'ls-files', '-z', '--cached', '--others', '--exclude-standard']
).decode().split('\0')
files = sorted(set(filter(None, files)))
required = ['README.md', '.env.example', '.gitignore', '.gitattributes',
            'compose/compose.yaml', 'config/recyclarr/recyclarr.yml',
            'config/recyclarr/secrets.example.yml', 'scripts/validate-repo.sh',
            '.github/workflows/validate.yml', 'docs/assets/architecture.mmd']
required += ['docs/' + n + '.md' for n in
             ['ARCHITECTURE', 'DEPLOYMENT', 'SECURITY', 'OPERATIONS', 'STORAGE',
              'MEDIA-FLOW', 'RECOMMENDATIONS', 'ROADMAP']]
errors = [f'missing required file: {n}' for n in required if n not in files]
if not errors:
    readme = pathlib.Path('README.md').read_text(encoding='utf-8')
    diagram = pathlib.Path('docs/assets/architecture.mmd').read_text(encoding='utf-8')
    if readme.split('```mermaid\n', 1)[-1].split('```', 1)[0].strip() != diagram.strip():
        errors.append('README architecture diagram differs from editable source')
tokens = re.compile(r'-----BEGIN (?:[A-Z0-9]+ )*PRIVATE KEY-----|'
                    r'\bgh[pousr]_[A-Za-z0-9]{20,}\b|'
                    r'\bgithub_pat_[A-Za-z0-9_]{30,}\b|'
                    r'\bAKIA[A-Z0-9]{16}\b|\bxox[baprs]-[A-Za-z0-9-]{20,}|'
                    r'\bBearer\s+[A-Za-z0-9._-]{20,}', re.I)
assignment = re.compile(
    r'^\s*(?:-\s*)?[\w.-]*(?:password|passwd|api[_-]?key|token|secret)[\w.-]*'
    r'\s*[:=]\s*(.*?)\s*$', re.I)
safe = re.compile(r'^(?:REPLACE_WITH_[A-Z0-9_]+|!secret\s+\w+|\$\{[^}]+\})$')
for name in files:
    p = pathlib.Path(name)
    parts = [s.lower() for s in p.parts]
    example = name == '.env.example' or p.name.endswith(('.example.yml', '.example.yaml'))
    forbidden = (p.name.startswith('.env') and not example or
                 ('secret' in p.name.lower() or 'credential' in p.name.lower()) and not example or
                 p.suffix.lower() in {'.key', '.pem', '.p12', '.pfx', '.db', '.sqlite',
                                      '.sqlite3', '.log', '.zip', '.tgz', '.bak', '.backup'} or
                 any(x in {'runtime', 'state', 'data', 'media', 'downloads', 'transcode',
                           'cache', '__pycache__'} for x in parts))
    if forbidden:
        errors.append(f'forbidden publication path: {name}')
    if not p.is_file() or p.is_symlink():
        errors.append(f'not a regular readable file: {name}')
        continue
    try:
        content = p.read_text(encoding='utf-8')
    except (UnicodeError, OSError):
        errors.append(f'non-text or unreadable file requires review: {name}')
        continue
    for number, line in enumerate(content.splitlines(), 1):
        reason = None
        if tokens.search(line):
            reason = 'credential signature'
        if p.suffix in {'.yml', '.yaml'} or name.startswith('.env'):
            match = assignment.match(line)
            if match:
                value = match[1].split(' #', 1)[0].strip().strip('\"\'')
                if value and not safe.fullmatch(value):
                    reason = 'literal credential assignment'
        for literal in re.findall(r'(?<![\w.])(?:\d{1,3}\.){3}\d{1,3}(?![\w.])', line):
            try:
                address = ipaddress.ip_address(literal)
            except ValueError:
                continue
            if any(address in ipaddress.ip_network(net) for net in
                   [(0x0a000000, 8), (0xac100000, 12), (0xc0a80000, 16), (0x64400000, 10)]):
                reason = 'private or shared address'
        for literal in re.findall(r'(?<![\w:])(?:[0-9a-fA-F]{0,4}:){2,}[0-9a-fA-F:]{0,4}', line):
            try:
                address = ipaddress.ip_address(literal)
            except ValueError:
                continue
            if address.version == 6 and (address in ipaddress.IPv6Network((0xfc << 120, 7)) or
                                         address in ipaddress.IPv6Network((0xfe80 << 112, 10))):
                reason = 'private IPv6 address'
        if reason:
            # Never echo matched values into CI logs.
            errors.append(f'{name}:{number}: {reason}')
    if name.endswith('.sh') and b'\r' in p.read_bytes():
        errors.append(f'CRLF shell script: {name}')
stages = subprocess.check_output(['git', 'ls-files', '--stage']).decode().splitlines()
for line in stages:
    metadata, name = line.split('\t', 1)
    if name.endswith('.sh') and metadata.split()[0] != '100755':
        errors.append(f'shell script needs executable Git mode: {name}')
if errors:
    raise SystemExit('\n'.join('FAIL: ' + e for e in errors))
print(f'PASS: publication hygiene and content checks ({len(files)} files).')
PY

# No silent success when Compose is unavailable. Standalone Compose is useful
# for daemon-free checks; deployments normally use the Docker plugin.
if command -v docker >/dev/null && docker compose version >/dev/null 2>&1; then
    compose=(docker compose)
elif command -v docker-compose >/dev/null; then
    compose=(docker-compose)
else
    fail 'Docker Compose v2 is required; no Compose validation was performed.'
fi
"${compose[@]}" --env-file .env.example -f compose/compose.yaml config --quiet
git diff --check
git diff --cached --check
printf 'PASS: Compose configuration and diff whitespace.\n'
