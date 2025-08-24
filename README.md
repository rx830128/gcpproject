# プロジェクトドキュメント分割版（2025-08-21 生成）

巨大な `CLAUDE.md` をテーマ別に分割しました。下記の順で参照してください。

## 📁 ディレクトリ構造

- **governance/** - ルール・変更管理
  - `STANDARD_RULES.md` - プロジェクト管理ガイドライン
  
- **tracking/** - UTM方針・自動検出
  - `UTM_POLICY.md` - utm_creativeパラメータ管理方針
  
- **ads/** - Meta入稿ガイド
  - `META_NAMING_GUIDE.md` - Meta広告入稿ガイドライン
  
- **reports/** - レポート仕様・Chatwork自動送信
  - `REPORT_SPECS.md` - 統合レポート出力仕様
  - `CHATWORK_AUTOREPORT.md` - Chatwork自動レポート送信
  
- **integration/** - 統合アーキテクチャ・JOIN・時差
  - `SQUADBEYOND_DATA_FLOW.md` - SquadBeyondデータ統合システム
  
- **data/** - データ契約・ビュー構成・SQL
  - `CURRENT_BQ_CONFIG.md` - 現在のBigQuery構成
  
- **systems/** - GCP/ローカル自動化・形態素解析
  - `SQUADBEYOND_GCP_SYSTEM.md` - SquadBeyond GCPシステム
  
- **incidents/** - 障害・緊急対応
  - `EMERGENCY_FIXES_2025-08-16.md` - 緊急修正必要事項
  
- **updates/** - 更新ログ
  
- **bridge/** - アカウントID↔レポートID

## 📋 プロジェクト構成

### 1. SquadBeyond自動化（Google Cloud Run版）
- **場所**: `C:\Users\rx830\squadbeyond-gcp\`
- **概要**: SquadBeyondからCSVレポートを3時間おきに自動取得、GCS保存、BigQuery連携
- **運用**: Google Cloud Run + Cloud Scheduler + BigQuery

### 2. SquadBeyond自動化（ローカル版）
- **場所**: `C:\Users\rx830\` （ルートディレクトリ）
- **メインスクリプト**: `squadbeyond_automation_today_loco.py`
- **概要**: SquadBeyondからCSVレポートをダウンロードし、Googleスプレッドシートにアップロード

### 3. 形態素分析ツール
- **場所**: `C:\Users\rx830\OneDrive\デスクトップ\形態素分析\`
- **メインスクリプト**: `adg_query.py`
- **概要**: 検索語句レポートの形態素解析とCPA分析

## 🔧 運用ガイドライン

Geminiと協業して開発を進めてください。（SSoT: 本分割ドキュメント一式）

### 新しいルールの追加プロセス
1. 「これを標準のルールにしますか？」と質問する
2. YES の回答を得た場合、該当ファイルに追加ルールとして記載する
3. 以降は標準ルールとして常に適用する

### ドキュメント更新時の注意
- 変更箇所には日付を併記
- 重要な変更は updates/ ディレクトリに変更履歴として記録
- 新規インシデントは incidents/ ディレクトリに追加