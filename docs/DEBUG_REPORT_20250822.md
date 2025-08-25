# デバッグレポート（2025-08-22〜25）

## 主な事象
- Container import failed（AR 権限/タグ）
- `'BridgeConfig' object has no attribute 'base_dir'`
- Secret Manager import エラー
- `BRIDGE_DIR` の Windows 変換（MSYS）
- unknown_* 保存パス

## 克服ポイント
1. AR 権限付与・タグ整備 → デプロイ成功
2. BridgeConfig に `base_dir` 追加（後方互換）
3. `google-cloud-secret-manager` / `PyYAML` 追加
4. Cloud Run env: `BRIDGE_DIR=/app/bridge`, `TZ=Asia/Tokyo`
5. `tools/validate_registry.py` で YAML をビルド時チェック
6. `report_registry.yaml` を最終化 → unknown_* 消滅