# プロジェクト基本原則（GCP統合計画）
- Git を唯一の正（SSOT）とする。PR レビュー＋CI を必須化。
- 機密はコード／ドキュメントへ書かず Secret Manager／IAM で管理。
- Cloud Run 環境変数：`BRIDGE_DIR=/app/bridge` を固定（Git Bash は `MSYS_NO_PATHCONV=1`）。
- データ取得・自動処理は再現可能性（バージョン／タグ固定、実行ログ）を担保。
- ログ方針：`[login2] [team2] [nav2] [diag]` を info 出力し、可観測性を確保。