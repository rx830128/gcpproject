# Deployment Status — 2025‑09‑01

## Current Stable
- Revision: `squadbeyond-scraper-00132-vfs` (v1.0.3)
- Traffic: stable=100%
- SLA: success 5/5, p95=132s
- Resources: memory=4Gi, cpu=2, concurrency=1

## Canary Findings
- Newer revisions (00135/00138/00150) failed at Chrome startup/download across all headless modes.
- Hypothesis: deploy-time runtime/env drift (not memory/env vars alone).

## Decision
- Keep 00132-vfs as baseline; improvements only via canary=0%.

## Next
- Try Xvfb (none), Chrome/Driver pin, controlled memory steps.
- Use scripts provided in `scripts/` for safe experiments.