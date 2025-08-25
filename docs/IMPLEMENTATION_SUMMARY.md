# 実装・復旧サマリー（2025-08）

## 背景
- Cloud Run 本番で **チーム選択失敗**（ヘッドレス/SPAタイミング差が原因）
- Artifact Registry 権限/タグ不整合で **image not found**、revision not ready
- Windows Git Bash による `BRIDGE_DIR` 変換で `/app/bridge` → `C:/Program Files/Git/app/bridge` 化
- YAML 不整合により **unknown_* パス** で保存

## 対応
- Chrome 起動オプション最適化、SPA待機強化、証跡保存追加
- BridgeConfig に `base_dir` 後方互換追加
- `tools/validate_registry.py` 導入（ビルド時に schema 検証）
- Cloud Build 専用 `cloudbuild.docker.yaml` 導入（tag を必ず push）
- `BRIDGE_DIR=/app/bridge`, `TZ=Asia/Tokyo` 設定
- `bridge/report_registry.yaml` を **最終版**へ（unknown_* 完全解消）

## 現在の状態
- `/bridge_status` = operational / validation=OK / total_active=2
- Scheduler — 毎時実行（JST）、URI は現行 URL
- GCS — 本日分は確認随時（ログで保存痕跡を追える）