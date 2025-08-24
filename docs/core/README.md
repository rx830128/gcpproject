# GCP統合計画（SquadBeyond スクレイパ安定運用）
- 実行環境：Cloud Run（asia-northeast1、サービス名 `squadbeyond-scraper`）
- Artifact Registry：`cloud-run`（Reader 付与済）
- Secret：`SQUAD_THEMARCH01_EMAIL` / `SQUAD_THEMARCH01_PASSWORD`（versions/latest）
- Bridge：`BRIDGE_DIR=/app/bridge` 固定
- 主要ドキュメント：`docs/core/`・`docs/records/`・`docs/squadbeyond-gcp/`