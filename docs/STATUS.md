# 稼働状況サマリ（2025-08-24）

- **Cloud Run**: `squadbeyond-scraper`（asia-northeast1）
  - サービスURL（直近の記録例）: `https://squadbeyond-scraper-257057741446.asia-northeast1.run.app`
  - `BRIDGE_DIR=/app/bridge`（Windows Git Bash のパス変換対策済）

- **Bridge 設定**:
  - `/bridge_status` = **OK**（`accounts` 読み込み成功）
  - `accounts`: `squad_themarch01`（team_name=Annulus）
  - `report_registry`: Active 2件（SmartNews/Popin 相当）

- **API 動作**:
  - `/enhanced_download` = **OK**（約13秒で2レポート処理、日付によりデータ無しの error あり）

- **ログ**:
  - Cloud Logging 出力は確認済み
  - 新タグ（`[login2] [team2] [nav2] [diag]`）は未検出 → 今後の実装確認項目

- **既知の軽微課題**:
  - Secret Manager ImportError: `cannot import name 'secretmanager' from 'google.cloud'`
    - 対処: `google-cloud` メタを外し、`google-cloud-secret-manager>=2.20.0` を追加（patch 同梱）