# デバッグ報告（2025-08-22）
- 事象：Cloud Run でチーム選択が失敗（ヘッドレス差分、SPA描画待機不足）
- 対応：Chrome 起動オプション最適化／待機強化／証跡保存
- 追加：BridgeConfig 後方互換（base_dir→bridge_dir）
- 結果：/bridge_status・/enhanced_download 正常。ログタグは未検出で今後対応。