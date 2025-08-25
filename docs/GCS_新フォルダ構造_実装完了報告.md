# GCS 新フォルダ構造 実装完了報告

## 仕様
`gs://squadbeyond-automation-data/hizakoshi/<platform>/report-<report_id>/%Y/%m/%Y-%m-%d/*.csv`

## 例
- SmartNews:
  `.../hizakoshi/smartnews/report-MEDPFSut_knir_Cc_OiA/2025/08/2025-08-25/*.csv`
- Popin:
  `.../hizakoshi/popin/report-yJoEVSBZiQGcPEEZw/2025/08/2025-08-25/*.csv`

## 備考
- 日付は `TZ=Asia/Tokyo` に基づく
- report_id は固定（GUI/URL由来）