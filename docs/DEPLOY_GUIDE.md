# デプロイガイド（更新 2025-08-24）

## IAM（Artifact Registry Reader）
```bash
SA_EMAIL=$(gcloud run services describe $SERVICE --region $REGION --format='value(spec.template.spec.serviceAccountName)')
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
CR_SA="service-$PROJECT_NUMBER@serverless-robot-prod.iam.gserviceaccount.com"
for SA in "$CR_SA" "$SA_EMAIL"; do
  gcloud artifacts repositories add-iam-policy-binding cloud-run --location="$REGION" \
    --member="serviceAccount:$SA" --role="roles/artifactregistry.reader"
done
```

## 環境変数（Git Bash は MSYS_NO_PATHCONV=1）
```bash
MSYS_NO_PATHCONV=1 gcloud run services update "$SERVICE" --region "$REGION" \
  --set-env-vars=^:^BRIDGE_DIR=/app/bridge:SB_HEADLESS_MODE=new:SB_VIEWPORT=1360,1024:TEAM_NAME=Annulus
```

## 安定デプロイ（明示タグ）
```bash
TAG="asia-northeast1-docker.pkg.dev/$PROJECT_ID/cloud-run/$SERVICE:manual-$(date +%Y%m%d-%H%M%S)"
gcloud builds submit --tag "$TAG"
gcloud run deploy "$SERVICE" --image "$TAG" --region "$REGION" \
  --allow-unauthenticated --timeout 300 --memory=2Gi --concurrency=1 \
  --set-env-vars BRIDGE_DIR=/app/bridge
```
