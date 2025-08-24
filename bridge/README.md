# bridge/ 設定（ひざこしコラーゲンw 反映済み）

このフォルダは SquadBeyond の **アカウント／レポートID／案件** を「設定として」管理します。

## ファイル
- `accounts.yaml` — ログインアカウント台帳（※生の認証情報は保持せず Secret Manager 参照のみ）
- `report_registry.yaml` — レポートID中心のSSOT（report_id → project_slug / platform / account_id）
- `project_registry.yaml` — 案件の表示名や通知先などのメタ情報

## 保存パス規約
`gs://{bucket}/{project_slug}/{platform}/report-{report_id}/YYYY/MM/DD/*.csv`

## Tips
- 実行環境に `BRIDGE_DIR` を設定すると安定します（例: `/workspace/bridge`）。
- 起動時に `bridge_runtime.config.validate()` を一度呼ぶと、設定ミスを即検知できます。
