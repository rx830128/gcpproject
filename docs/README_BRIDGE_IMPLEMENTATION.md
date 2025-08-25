# Bridge 実装詳細（強化版）

## 強化項目
- **ヘッドレス安定化**: `--no-sandbox`, `--disable-dev-shm-usage`, viewport固定, UA/言語固定
- **SPA待機ロジック**: `document.readyState=complete` → 要素 presence → visibility → clickable → JS click
- **チーム選択**: `/users/teams` 直遷移 + XPATH 正規化（`normalize-space`, 包含一致）+ JS click
- **証跡保存**: 失敗時に `/tmp/*.png / *.html / *_console.json`
- **BridgeConfig 後方互換**: `base_dir` プロパティ追加（内部で `bridge_dir` を返す）
- **Windows Git Bash 対策**: `MSYS_NO_PATHCONV=1` により `BRIDGE_DIR=/app/bridge` の C: 変換阻止
- **YAML 整合性**: `tools/validate_registry.py` による build-time バリデーション

## エンドポイント
- `/bridge_status` — config_path が `/app/bridge`、reports_summary.total_active=2 を確認
- `/enhanced_download` — [login2]/[team2]/[nav2] ログと gs:// 保存痕跡を確認