# Meta × SquadBeyond 統合システム 実装完了報告書
**作成日**: 2025年8月15日 19:20  
**システム状態**: ✅ 本番稼働中

## 📊 システム概要

Meta広告データ（コスト・配信実績）とSquadBeyondデータ（LP〜CV実績）を統合し、リアルタイムで16指標を自動計算するシステムを構築・稼働開始しました。

## 🎯 完成した16指標

| # | 指標名 | データソース | 計算式 | 状態 |
|---|--------|------------|--------|------|
| 1 | COST（広告費） | Meta API | spend | ✅ |
| 2 | IMP（表示回数） | Meta API | impressions | ✅ |
| 3 | CPM（1000表示単価） | Meta計算 | COST/(IMP/1000) | ✅ |
| 4 | CTs（クリック数） | Meta API | clicks | ✅ |
| 5 | CTR（クリック率） | Meta計算 | CTs/IMP × 100 | ✅ |
| 6 | CPC（クリック単価） | Meta計算 | COST/CTs | ✅ |
| 7 | FVSR（FVS突破率） | SquadBeyond計算 | fvs_breakthrough/version_pv × 100 | ✅ |
| 8 | FVS単価 | 統合計算 | COST/fvs_breakthrough | ✅ |
| 9 | OAR（オファー到達率） | SquadBeyond計算 | offer_reach/version_pv × 100 | ✅ |
| 10 | OA単価 | 統合計算 | COST/offer_reach | ✅ |
| 11 | 遷移数 | SquadBeyond | version_click | ✅ |
| 12 | 遷移率 | SquadBeyond計算 | version_click/version_pv × 100 | ✅ |
| 13 | 遷移単価 | 統合計算 | COST/version_click | ✅ |
| 14 | CV（コンバージョン） | SquadBeyond | version_cv | ✅ |
| 15 | CVR（CV率） | SquadBeyond計算 | version_cv/version_click × 100 | ✅ |
| 16 | CPA（獲得単価） | 統合計算 | COST/version_cv | ✅ |

## 🏗️ システムアーキテクチャ

### データフロー
```
Meta広告管理画面
    ↓ (API)
Meta API ← 毎時0分実行
    ↓
BigQuery: meta_ads_hourly
    ↓
統合ビュー: integrated_hourly_analysis ← 16指標自動計算
    ↑
BigQuery: squadbeyond_reports
    ↑
SquadBeyond ← 毎時5分実行
    ↑ (Selenium)
SquadBeyondレポート画面
```

### 実装コンポーネント