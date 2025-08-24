# 📊 現在のBigQuery構成（2025年8月20日大幅更新）

## メインテーブル（使用推奨度別）
**✅ 推奨テーブル**
- `squadbeyond_reports_corrected_v3` - SquadBeyond統合用（hour修復済み、案件名修正済み）
- `meta_ads_hourly` - Meta広告元データ（当日データ取得修正済み）

**⚠️ 補助テーブル**  
- `meta_ads_hourly_fixed` - report_name修正済み（現在データ不足のため非推奨）
- `squadbeyond_reports_corrected` - v3以前の旧バージョン
- `meta_ads_daily` - Meta広告日別データ

## 新統合ビュー設計（2025年8月20日実装）
**🎯 「当日=時間推移」＋「昨日以前=日単位」の両立設計**

**メイン統合ビュー（修正版）**
- `vw_intraday_today_fixed` - **当日時間別推移**（UTM分割修正済み）
- `vw_daily_integrated_history_fixed` - **過去日別確定データ**（UTM分割修正済み）
- `vw_today_cumulative_integrated_fixed` - **当日累積1行**（レポート用）

**旧統合ビュー（参考）**
- `integrated_final_report_v2` - 統合キー修正版
- `integrated_hourly_analysis_fixed` - fvser対応版
- その他従来ビュー多数（段階的に新ビューへ移行予定）

## 詳細構成（2025年8月19日更新）

### メインテーブル
| テーブル名 | 用途 | レコード数 | 最終更新 |
|-----------|------|----------|---------|
| `squadbeyond_reports_corrected_v3` | **推奨** SquadBeyond統合用（hour修復済み） | 2,826行 | 2025-08-19 04:06 |
| `meta_ads_hourly_fixed` | **推奨** Meta広告統合用（report_name修正済み） | 8,619行 | 2025-08-17 14:00 |
| `meta_ads_hourly` | Meta広告元データ | 9,955行 | 2025-08-19 07:00 |

### 統合ビュー
| ビュー名 | 用途 | 統合率 | 状態 |
|---------|------|--------|------|
| `integrated_final_report` | **最新推奨** 時間別統合レポート | - | ✅ 正常 |
| `integrated_daily_analysis_final` | 日別統合レポート | 86.4% | ✅ 正常 |
| `integrated_hourly_analysis_final` | 時間別統合レポート（旧） | 0% | ⚠️ 要更新 |

### JOINキー構成
```sql
-- 正しいJOIN条件（時間別）
ON s.date_str = m.date_str
AND s.hour_of_day = m.hour_of_day
AND s.report_name = m.report_name
AND s.ad_group_name = m.ad_group_name
AND s.creative_name = m.creative_name
```

## 🔧 BigQueryコマンド集

### PowerShellコマンド形式の注意事項
- **バッククォート（`）** を行末に付けて複数行に分割
- **ダブルクォート内のバッククォート** は `\`` でエスケープ
- **読みやすさ** と **コピペしやすさ** を重視

```powershell
# データ件数確認
bq query --use_legacy_sql=false `
  'SELECT COUNT(*) as total_rows FROM `squadbeyond-automation.squadbeyond_data.squadbeyond_reports`'

# 最新データ確認
bq query --use_legacy_sql=false `
  'SELECT * FROM `squadbeyond-automation.squadbeyond_data.squadbeyond_reports` `
   ORDER BY processed_at DESC LIMIT 10'

# report_name別集計
bq query --use_legacy_sql=false `
  'SELECT report_name, COUNT(*) as rows `
   FROM `squadbeyond-automation.squadbeyond_data.squadbeyond_reports` `
   GROUP BY report_name'

# utm_creativeパラメータ確認
bq query --use_legacy_sql=false `
  "SELECT DISTINCT parameter `
   FROM \`squadbeyond-automation.squadbeyond_data.squadbeyond_reports\` `
   WHERE parameter LIKE 'utm_creative=%'"

# テーブル情報
bq show `
  squadbeyond-automation:squadbeyond_data.squadbeyond_reports

# スキーマ確認
bq show --schema --format=prettyjson `
  squadbeyond-automation:squadbeyond_data.squadbeyond_reports
```