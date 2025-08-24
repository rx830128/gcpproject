# 運用手順（RUNBOOK）更新 2025-08-24

## 毎日
1. `/health` と `/bridge_status` を確認（`accounts` が空でない）
2. `enhanced_download` を実行
3. ログで `[login2] [team2] [nav2] [diag]` を確認

### ログクエリ
```bash
gcloud logging read '
  resource.type=cloud_run_revision
  AND resource.labels.service_name=squadbeyond-scraper
  AND (textPayload:("[login2]" OR "[team2]" OR "[nav2]" OR "[diag]")
    OR jsonPayload.message:("[login2]" OR "[team2]" OR "[nav2]" OR "[diag]"))
' --limit=200 --format='value(timestamp,severity,textPayload,jsonPayload.message)'
```

## トラブルシュート
- **accounts: {}** → `BRIDGE_DIR` を再設定（Git Bash は `MSYS_NO_PATHCONV=1`）
- **ImportError (secretmanager)** → requirements を是正（patch 参照）
