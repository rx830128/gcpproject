# Chrome Crash Troubleshooting (Cloud Run)

## Symptoms
- Crash across headless new/old/none on newer revisions; baseline 00132-vfs OK.

## Likely Causes
- Runtime/env drift at deploy time, /dev/shm pressure, blob-based export load.

## Playbook
1) Keep stable revision untouched.
2) Canary=0% only.
3) Try in order:
   - Memory: 4Gi → 6Gi/8Gi (temporary)
   - SB_HEADLESS_MODE: new → old → none (Xvfb)
   - Chrome flags: --disable-dev-shm-usage --no-sandbox --disable-gpu --disable-software-rasterizer --no-first-run --no-default-browser-check --js-flags=--max-old-space-size=2048
   - Chrome/Driver pin (Dockerfile)
4) Measure with 5-run smoke; gate on OK≥4/5 & p95≤300s.