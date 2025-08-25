#!/usr/bin/env python3
import sys, pathlib, yaml
p = pathlib.Path('/app/bridge/report_registry.yaml')

try:
    data = yaml.safe_load(p.read_text(encoding='utf-8'))
except FileNotFoundError:
    print("report_registry.yaml missing at /app/bridge", file=sys.stderr)
    sys.exit(2)

assert isinstance(data, dict), "YAML root must be a mapping"
assert data.get('version') == 1, "missing or wrong version"
reports = data.get('reports')
assert isinstance(reports, list) and reports, "reports not found"

required = ('report_id','project_id','account_id','platform','project_slug','save_prefix','active')
for i, r in enumerate(reports):
    for k in required:
        if k not in r or r[k] in (None, ''):
            raise AssertionError(f"missing key: {k} in report index {i}")

print("report_registry.yaml OK")