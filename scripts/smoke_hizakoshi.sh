#!/usr/bin/env bash
set -euo pipefail
REGION=${REGION:-asia-northeast1}
SERVICE=${SERVICE:-squadbeyond-scraper}
BUCKET=${BUCKET:-squadbeyond-data-tanaka}
RID_PREFIX=${1:-"smoke-$(date +%Y%m%d-%H%M%S)"}
REPORT_ID=${REPORT_ID:-MEDPFSut_knir_Cc_OiA}
TARGET_DATE=${TARGET_DATE:-2025-09-01}

CANARY_URL=$(gcloud run services describe "$SERVICE" --region "$REGION" \
  --format="value(status.traffic[?(@.tag=='canary')].url)")
echo "CANARY_URL=$CANARY_URL"

for i in {1..5}; do
  RUN_ID="$RID_PREFIX-$i"
  curl -fsS -X POST "$CANARY_URL/enqueue" -H "Content-Type: application/json" \
    -d "{\"platform\":\"SmartNews\",\"report_ids\":[\"$REPORT_ID\"],\"target_date\":\"$TARGET_DATE\",\"run_id\":\"$RUN_ID\"}"
done

ok=0; total=0; max=0
for i in {1..5}; do
  RUN_ID="$RID_PREFIX-$i"
  s=$(gsutil cat gs://$BUCKET/jobs/$RUN_ID/status.json 2>/dev/null || true)
  [[ -z "$s" ]] && { echo "$RUN_ID no status"; continue; }
  st=$(echo "$s" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p' | head -n1)
  dur=$(echo "$s" | sed -n 's/.*"duration_ms":\([0-9]\+\).*/\1/p' | head -n1)
  echo "$RUN_ID state=$st duration_ms=${dur:-0}"
  total=$((total+1)); [[ "$st" = "done" ]] && ok=$((ok+1))
  [[ "$dur" =~ ^[0-9]+$ ]] && (( dur>max )) && max=$dur
done
echo "OK=$ok/$total  p95=${max}ms (= $((max/1000)) s)"