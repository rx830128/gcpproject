# Changelog

## v1.0.3 (HOLD) — 2025‑09‑01
- Baseline: revision `squadbeyond-scraper-00132-vfs` (stable=100%)
- Field results: 5/5 success, p95=132s, mem=4Gi / cpu=2 / concurrency=1
- Newer revisions (00135/00138/00150) canary failed due to Chrome crash (all headless modes). Root cause suspected: runtime/env drift during deploy. Decision: **keep 00132-vfs as stable baseline** and move improvements behind canary+no-traffic only.