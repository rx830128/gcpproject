# Bridge 実装完了報告（要約）
- `base_dir` → 互換プロパティで `bridge_dir` を返却（後方互換）
- 環境変数固定：`BRIDGE_DIR=/app/bridge`
- Selenium 安定化：`--headless=new --no-sandbox --disable-dev-shm-usage --window-size=1360,1024`
- SPA待機：presence → visibility → clickable
- 失敗時証跡：PNG/HTML/console を `/tmp` 保存（将来 GCS 送付可能）