# META — Cloud Run Status

- Service: `squadbeyond-scraper`
- Env:
  - `BRIDGE_DIR=/app/bridge`
  - `TZ=Asia/Tokyo`
  - `SB_HEADLESS_MODE=new`
  - `SB_VIEWPORT=1360,1024`
- Timeout: 300 sec, Memory: 2Gi, Concurrency: 1
- Endpoints: `/health`, `/bridge_status`, `/enhanced_download`