#!/usr/bin/env bash
set -euo pipefail

SERVICE=${SERVICE:-squadbeyond-scraper}
REGION=${REGION:-asia-northeast1}

URL=$(gcloud run services describe "$SERVICE" --region "$REGION" --format='value(status.url)')
echo "URL=$URL"

echo "[1] bridge_status"
curl -fsS "$URL/bridge_status" | jq . || curl -fsS "$URL/bridge_status" || true

echo "[2] enhanced_download (enhanced=true)"
curl -fsS -X POST "$URL/enhanced_download" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -d '{"enhanced": true}' | jq . || true

echo "[3] logs (login2/team2/nav2/diag)"
gcloud logging read "
resource.type=cloud_run_revision
AND resource.labels.service_name=$SERVICE
AND (
  textPayload:('[login2]' OR '[team2]' OR '[nav2]' OR '[diag]') OR
  jsonPayload.message:('[login2]' OR '[team2]' OR '[nav2]' OR '[diag]')
)" --limit=200 --format='value(timestamp,severity,textPayload,jsonPayload.message)'