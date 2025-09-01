#!/usr/bin/env bash
set -euo pipefail
REGION=${REGION:-asia-northeast1}
SERVICE=${SERVICE:-squadbeyond-scraper}
MEM=${1:-4Gi}
CPU=${2:-2}
HEADLESS=${HEADLESS:-old}
TIMEOUT=${TIMEOUT:-600}

echo ">> reading stable image from 00132-vfs"
IMG_SPEC=$(gcloud run revisions describe squadbeyond-scraper-00132-vfs --region "$REGION" --format="value(spec.containers[0].image)")
IMG_DIGEST=$(gcloud run revisions describe squadbeyond-scraper-00132-vfs --region "$REGION" --format="value(status.imageDigest)")
IMAGE="${IMG_SPEC:-$IMG_DIGEST}"

echo ">> deploy no-traffic with mem=$MEM cpu=$CPU headless=$HEADLESS"
gcloud run deploy "$SERVICE" --region "$REGION" \
  --image "$IMAGE" \
  --memory "$MEM" --cpu "$CPU" --concurrency 1 \
  --set-env-vars "SB_HEADLESS_MODE=$HEADLESS,SB_DOWNLOAD_TIMEOUT=$TIMEOUT" \
  --no-traffic --quiet

NEW_REV=$(gcloud run revisions list --service "$SERVICE" --region "$REGION" \
  --sort-by="~metadata.creationTimestamp" --limit=1 --format="value(metadata.name)")
echo ">> tag canary=$NEW_REV (0%)"
gcloud run services update-traffic "$SERVICE" --region "$REGION" --set-tags "canary=$NEW_REV"
echo "done: $NEW_REV"