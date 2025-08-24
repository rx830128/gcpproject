# SquadBeyond GCP システム

## 📊 システム概要（2025年8月13日更新・デプロイ済み）

### データフロー
```
SquadBeyond CSV取得 (3時間おき)
         ↓
    GCS保存 (既存)
         ↓
   CSV処理・計算 (NEW)
         ↓
  BigQuery自動アップロード (NEW)
         ↓
  Googleスプレッドシート連携 (既存)
         ↓
  Chatworkレポート送信 (2025年8月16日追加)
```

### 新機能（2025年8月13日実装・デプロイ済み）

**1. BigQuery連携強化**
- 新しいテーブルスキーマ（`bigquery_schema_updated.json`）
- 取り込み時刻の自動記録（`processed_at`）
- utm_creative別集計対応

**2. 計算項目の自動生成**
- **FVS突破数** = versionPV × FVER ÷ 100
- **オファー到達数** = versionPV × OAR ÷ 100

**3. CSVヘッダーエラー自動修正**
- `"key '日付 (ja)' returned an object instead of string."` → `"日付"`に自動修正

### BigQueryテーブル構造

必要な全項目：
- 日付、Version名、パラメーター（utm_creative別集計用）
- versionPV、versionCLICK、versionCTR、versionCV
- versionCVR、versionCTVR、versionCPA、versionMCPA
- FVER、SVER、FSVER、OAR
- **FVS突破数**（新規計算）、**オファー到達数**（新規計算）
- processed_at（取り込み時刻）

### データ集計ルール
- **パラメーター列が空**: 全体集計として使用
- **パラメーター列に値**: utm_creative別の詳細データとして集計

### ファイル構成（2025年8月13日版）
```
squadbeyond-gcp/
├── main.py                          # Flask Webアプリ
├── selenium_handler.py              # Selenium自動化 + BigQuery連携
├── storage_handler.py               # GCS保存処理
├── csv_processor.py                 # CSV処理・計算（NEW）
├── bigquery_schema_updated.json     # 新BigQueryスキーマ（日本語版）
├── bigquery_schema_utf8.json        # UTF-8対応版スキーマ（実用版）
├── bigquery_schema.json             # 旧スキーマ（参考）
├── requirements.txt                 # 依存関係（pandas, bigquery追加）
├── Dockerfile                       # コンテナ設定
├── env.yaml                         # 環境変数
├── cloudbuild.yaml                  # Cloud Build設定
└── SYSTEM_COMPLETE.md               # 運用マニュアル
```

### 運用状況（2025年8月16日更新）
- **実行頻度**: 
  - データ取得: 1時間おき（毎時5分）
  - Chatworkレポート: 1時間おき（毎時10分）
- **対象案件**: 2件（案件B、ロコヘルプ_FB）
  - **案件詳細**: 
    - 案件B: 複数バージョン（Ver.3780, Ver.3985, 各種テスト版等）
    - ロコヘルプ_FB: Ver.244751（Facebook広告連携）
- **データ保存**: GCS + BigQuery + Googleスプレッドシート + Chatwork
- **BigQuery連携**: ✅ 稼働中（2025年8月13日〜）
- **Meta広告当日データ**: ✅ meta_ads_hourlyテーブルで最新時間まで取得
- **Chatworkレポート**: ✅ 稼働中（2025年8月16日〜）
- **Cloud Scheduler**: 
  - `squadbeyond-auto-download` (asia-northeast1) - `5 * * * *`
  - `chatwork-hourly-report` (asia-northeast1) - `10 * * * *`
- **Cloud Run**: `squadbeyond-scraper` (asia-northeast1)

### デプロイコマンド
```powershell
cd C:\Users\rx830\squadbeyond-gcp
gcloud builds submit --config=cloudbuild.yaml --project=squadbeyond-automation
```

### BigQueryエラー修正履歴（2025年8月13日）

**問題**: システム実行時にBigQuery挿入エラーが発生
- エラー内容: `no such field: parameter`, `no such field: fvs_breakthrough` 等
- 原因: BigQueryデータセット・テーブルが存在しない

**修正手順**:
1. ✅ BigQueryデータセット作成: `squadbeyond-automation:squadbeyond_data`
2. ✅ UTF-8エンコーディング対応スキーマ作成: `bigquery_schema_utf8.json`
3. ✅ 新スキーマでテーブル作成: 全20フィールド対応
4. ✅ エラー解決確認済み

**作成されたファイル**:
- `bigquery_schema_utf8.json`: エンコーディング問題修正版スキーマ

### トラブルシューティング

**🔴 重要: BigQueryクライアント必須（2025年8月15日障害事例）**
- **症状**: `BigQuery update error: [Errno 2] No such file or directory: 'bq'`
- **原因**: Cloud RunコンテナにBigQueryクライアント（bqコマンド）未インストール
- **影響**: SquadBeyondデータのBigQuery更新が停止（Meta広告は正常）
- **解決**: Dockerfileに`google-cloud-cli`パッケージ追加が必須
- **確認コマンド**: 
  ```bash
  # エラーログ確認
  gcloud logging read "resource.type=cloud_run_revision AND textPayload:'No such file or directory: bq'" --limit=5
  # BigQuery処理成功確認
  gcloud logging read "textPayload:'bigquery' AND textPayload:'行を正常に挿入'" --limit=5
  ```

**BigQuery関連エラー**:
- `Dataset not found` → データセット作成: `bq mk --dataset --location=asia-northeast1 squadbeyond-automation:squadbeyond_data`
- `Table not found` → テーブル作成: `bq mk --table squadbeyond-automation:squadbeyond_data.squadbeyond_reports bigquery_schema_utf8.json`
- `no such field` → スキーマ不整合、テーブル再作成が必要
- `No such file or directory: 'bq'` → Dockerfileに`google-cloud-cli`追加必須

**ログ確認コマンド**:
```powershell
# Cloud Runログ確認
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=squadbeyond-scraper" --project=squadbeyond-automation --limit=50

# Cloud Scheduler状況確認
gcloud scheduler jobs describe squadbeyond-auto-download --location=asia-northeast1 --project=squadbeyond-automation
```

### 完了タスク（2025年8月14日）
- [x] csv_processor.py実装（CSV処理・計算機能）
- [x] BigQuery連携機能の実装
- [x] Cloud Runへのデプロイ完了
- [x] BigQueryデータセット・テーブル作成
- [x] スキーマエラー修正完了
- [x] BigQueryデータ挿入の動作確認 ✅ 67行正常挿入
- [x] Cloud Scheduler 1時間おき設定完了

### 次回のタスク
- [ ] Googleスプレッドシート側の計算項目追加
- [ ] 異常時のアラート通知設定
- [ ] BigQueryデータの可視化（Looker Studio等）