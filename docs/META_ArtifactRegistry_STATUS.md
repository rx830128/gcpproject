# META — Artifact Registry / Cloud Build

- Repo: `cloud-run`（asia-northeast1）
- Tag 運用: `manual-YYYYMMDD-HHMMSS`
- Build 定義: `cloudbuild.docker.yaml`（_IMAGE にタグを渡す）
- 確認:
```bash
gcloud artifacts docker tags list \
  asia-northeast1-docker.pkg.dev/$PROJECT_ID/cloud-run/squadbeyond-scraper \
  --format='table(TAGS,DIGEST,CREATE_TIME)' | head -10
```