# SquadBeyond GCP Bridge

Cloud Run 上で SquadBeyond のレポートを自動ダウンロードし、GCS に保存するブリッジ実装です。

## 構成
- **Cloud Run**: `squadbeyond-scraper`
- **Artifact Registry**: `asia-northeast1-docker.pkg.dev/<PROJECT_ID>/cloud-run/squadbeyond-scraper`
- **Cloud Scheduler**: 毎時実行（JST）
- **Secret Manager**: ログイン情報（メール/パスワード）のみ Secret 参照
- **GCS**: 保存先バケット `gs://squadbeyond-automation-data/`

## エンドポイント
- `GET /health` — ライブネス
- `GET /bridge_status` — Bridge 読み込み状態（config_path、accounts、reports_summary など）
- `POST /enhanced_download` — 強化ルートでの実行（Selenium ナビゲーション含む）

## 環境変数（Cloud Run）
- `BRIDGE_DIR=/app/bridge`
- `TZ=Asia/Tokyo`（日付パスを日本時間で生成）
- `SB_HEADLESS_MODE=new`
- `SB_VIEWPORT=1360,1024`

## 保存パス設計（例）

```
gs://squadbeyond-automation-data/hizakoshi/<platform>/report-<report_id>/%Y/%m/%Y-%m-%d/*.csv
```

## ビルド／デプロイ
- 最小 Cloud Build 定義: `cloudbuild.docker.yaml`
- Dockerfile は `COPY requirements.txt → pip install → COPY .` の順
- ビルド時に `tools/validate_registry.py` が走り、YAML 整合性が崩れていれば**ここで fail**

## ログクエリ（例）
```bash
# 強化ルートタグや保存ログ
gcloud logging read \
"resource.type=cloud_run_revision AND resource.labels.service_name=squadbeyond-scraper AND \
 (textPayload:('[login2]' OR '[team2]' OR '[nav2]' OR 'gs://' OR 'saved' OR 'upload'))" \
--limit=80 --format='table(timestamp,severity,textPayload)'
```

## セキュリティ
- 秘密はSecret Managerのみ。リポジトリには生情報を置かない
- 実行 SA に最低限のロール（secretmanager.secretAccessor / artifactregistry.reader / storage.objectCreator）