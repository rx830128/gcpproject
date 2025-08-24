# 📈 統合レポート出力仕様

## 手動レポート出力仕様
**最新時間の統合レポート指標（必須）**:
- 最新時間のデータのみ使用（前の時間帯データは使用無し）
- **推奨データ取得パス**: `integrated_hourly_analysis`ビュー（20時まで更新済み）
- **代替パス**: 個別テーブル結合（`squadbeyond_reports` + `meta_ads_hourly`）
- 以下の指標を含む：

| 指標名 | 計算式 | データソース |
|--------|--------|-------------|
| COST | - | 広告媒体のコスト |
| IMP | - | 広告媒体の表示回数 |
| CPM | COST/(IMP/1000) | 計算 |
| CTs | - | 広告媒体のクリック数 |
| CTR | CTs/IMP | 計算 |
| CPC | COST/CTs | 計算 |
| FVSR | FVER | SquadBeyond |
| FVS単価 | COST/(versionPV×FVER÷100) | 計算 |
| OAR | OAR | SquadBeyond |
| OA単価 | COST/(versionPV×OAR÷100) | 計算 |
| 遷移数 | version_click | SquadBeyond |
| 遷移率 | version_click/version_pv | 計算 |
| 遷移単価 | COST/version_click | 計算 |
| CV | version_cv | SquadBeyond |
| CVR | version_cv/version_click | 計算 |
| CPA | COST/version_cv | 計算 |