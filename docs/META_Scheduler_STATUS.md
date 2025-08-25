# META — Scheduler Status

- Job: `sbscraper-hourly`
- Location: `asia-northeast1`
- Schedule: `0 * * * *`（JST）
- Auth: OIDC（Cloud Run 実行SA）
- URI: 現行 `https://<current-url>/enhanced_download`

## 即時実行
```bash
gcloud scheduler jobs run sbscraper-hourly --location=asia-northeast1
```