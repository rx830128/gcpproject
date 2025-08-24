# GCP統合計画: プロジェクト指示（更新 2025-08-24）

本プロジェクトは Cloud Run 上で SquadBeyond スクレイパを安定稼働させるための運用指針・設定を提供します。

## 必須運用ポリシー
- **BRIDGE_DIR の固定**: `/app/bridge`（または `/workspace/bridge`）
  - Windows Git Bash は `MSYS_NO_PATHCONV=1` を付けて `--set-env-vars` を実行（パス自動変換の罠回避）
- **Selenium 安定化**: `--headless=new --no-sandbox --disable-dev-shm-usage --window-size=1360,1024`
- **Secrets は必ず `versions/latest`**（固定番号禁止）
- **Artifact Registry の Reader 権限**を Cloud Run サービスエージェント／実行SAに付与（Container import failed 回避）
- **ログタグ**: `[login2] [team2] [nav2] [diag]` を `logger.info` で出力
- **BridgeConfig 後方互換**: `base_dir` は互換プロパティで `bridge_dir` を返す

## 代表コマンド
```bash
# Cloud Run（環境変数再設定。Git Bash はパス変換無効化）
MSYS_NO_PATHCONV=1 gcloud run services update "$SERVICE" --region "$REGION" \
  --set-env-vars=^:^BRIDGE_DIR=/app/bridge:SB_HEADLESS_MODE=new:SB_VIEWPORT=1360,1024:TEAM_NAME=Annulus

# 明示タグでの安定デプロイ
TAG="asia-northeast1-docker.pkg.dev/$PROJECT_ID/cloud-run/$SERVICE:manual-$(date +%Y%m%d-%H%M%S)"
gcloud builds submit --tag "$TAG"
gcloud run deploy "$SERVICE" --image "$TAG" --region "$REGION" \
  --allow-unauthenticated --timeout 300 --memory=2Gi --concurrency=1 \
  --set-env-vars BRIDGE_DIR=/app/bridge
```

## ログ確認テンプレ
```bash
gcloud logging read '
  resource.type=cloud_run_revision
  AND resource.labels.service_name='"'"'$SERVICE'"'"'
  AND (textPayload:("[login2]" OR "[team2]" OR "[nav2]" OR "[diag]")
    OR jsonPayload.message:("[login2]" OR "[team2]" OR "[nav2]" OR "[diag]"))
' --limit=200 --format='value(timestamp,severity,textPayload,jsonPayload.message)'
```

## トラブルシュート
- `/bridge_status` が `accounts: {}` → `BRIDGE_DIR` が Windows 形式に化けていないか。Git Bash は `MSYS_NO_PATHCONV=1`
- Container import failed → AR Reader 権限不足 / リージョン不一致
- Secret Manager ImportError → `google-cloud-secret-manager` を requirements に追加（同梱 patch）
