# CLAUDE.md — プロジェクト基本原則

## 1) 目的と適用範囲

SquadBeyondスクレイピング → Google Cloud Storage → BigQuery → Meta広告統合システムの運用管理。Geminiとの協業開発における標準ルール・原則・設計指針を定義。

### 🎯 最新ステータス（2025-08-22 14:00）
- **Cloud Run稼働中**: `enhanced-squad-system` (https://enhanced-squad-system-fooz2p22fa-an.a.run.app)
- **ログイン問題**: **100%解決済み** ✅
- **CSVダウンロード**: **正常動作確認済み** ✅
- **次回作業**: Cloud Scheduler再開（`squad-reports-hourly`）

## 2) 最重要ルール（標準化プロセス）

ユーザーから今回限りではなく常に対応が必要だと思われる指示を受けた場合：

1. 「これを標準のルールにしますか？」と質問する
2. YES の回答を得た場合、**このCLAUDE.mdに追加ルールとして記載**する
3. 以降は標準ルールとして常に適用する

このプロセスにより、プロジェクトのルールを継続的に改善していきます。

## 3) 不変の基本原則（要約）

### 名前空間分離方式
- utm_creative は **案件名＋パラメータ** で一意管理（"名前空間分離"）
- 異なる案件で同じパラメータ名使用を防止
- 詳細：`/docs/policies/utm_creative_namespace.md`

### 案件判別ルール
- 案件判別は **env.yaml のレポートID→案件名** による（内容ベース判定は禁止）
- SquadBeyond側：パラメータのみ記録、案件名は記録しない
- Cloud Run側：レポートIDから env.yaml を使って判別
- 詳細：`/docs/infra/data_flow_env_mapping.md`

### BigQuery統合原則
- 統合キー：**広告グループ_クリエイティブNo** で Meta ↔ SquadBeyond を結合
- JOIN条件：date_str, hour_of_day, report_name, ad_group_name, creative_name
- UTM分割：正規表現による正確な分割（前半=広告グループ、後半=クリエイティブNo）
- 詳細：`/docs/infra/bq_config.md`

### データ計算統一
- FV突破数：必ず `version_pv × FVER ÷ 100` で計算
- オファー到達数：必ず `version_pv × OAR ÷ 100` で計算
- fvs_breakthrough, offer_reachフィールド：直接使用禁止（異常値含む）

## 4) クイックリンク

### Policies（方針・規約）
- [utm_creative 名前空間分離方針](/docs/policies/utm_creative_namespace.md) - 案件別パラメータ一意管理
- [Meta広告入稿命名ガイド](/docs/policies/meta_naming_guide.md) - 命名規則・URLパラメータ一致

### Runbooks（運用手順）
- [Chatwork自動レポート](/docs/runbooks/chatwork_autoreport.md) - 毎時10分自動送信・構成・既知問題
- [統合レポート出力仕様](/docs/runbooks/reporting_specs.md) - KPI定義・計算式・取得パス

### Infra（基盤構成）
- [GCS新フォルダ構造](/docs/infra/gcs_layout.md) - project/platform/report-id階層
- [BigQuery最新構成](/docs/infra/bq_config.md) - 推奨ビュー・JOIN条件・UTM分割
- [データフロー・env.yaml管理](/docs/infra/data_flow_env_mapping.md) - レポートID→案件名マッピング
- [GCPシステム全体像](/docs/infra/gcp_system_overview.md) - Cloud Run・Scheduler・BigQuery構成

### Status/Incidents（状態・障害）
- [Enhanced最終状況（2025-08-21）](/docs/status/2025-08-21_enhanced_system.md) - 最新システム状況・認証・デプロイ
- [緊急修正記録（2025-08-16）](/docs/status/2025-08-16_emergency_fixes.md) - 案件名逆転・UTM分割修正履歴

## 5) 変更履歴（ダイジェスト）

- **2025-08-22 ✨**: **SquadBeyondログイン問題100%解決・Cloud Runデプロイ成功・CSVダウンロード完全動作確認**
- **2025-08-21**: Enhanced構成反映・Cloud Code統合パッケージ完了
- **2025-08-20**: GCS新フォルダ構造確定・UTM分割ロジック正規表現修正
- **2025-08-16**: Meta命名ガイドライン・Chatworkレポート仕様確定・緊急修正実施
- **2025-08-15**: utm_creative名前空間分離方針策定・自動検出システム完了

※詳細は `/docs/status/` を参照

## 6) プロジェクト構成

### 1. SquadBeyond自動化（GCP版）
- **場所**: `squadbeyond-gcp/`
- **概要**: SquadBeyondからCSVレポートを1時間おきに自動取得、GCS保存、BigQuery連携
- **運用**: Google Cloud Run + Cloud Scheduler + BigQuery

### 2. SquadBeyond自動化（ローカル版）
- **場所**: `squadbeyond/`
- **概要**: SquadBeyondからCSVレポートをダウンロード、Googleスプレッドシートアップロード

### 3. 形態素分析ツール
- **場所**: OneDrive上の形態素分析フォルダ
- **概要**: 検索語句レポートの形態素解析とCPA分析

---

**データ参照時の絶対ルール**: 2025年8月17日以降のデータのみ参照（16日以前は案件名逆転問題のため）