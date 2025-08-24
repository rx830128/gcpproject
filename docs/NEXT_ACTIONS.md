# Next Actions（このパッケージ反映後）

1) **requirements の Secret Manager 対応パッチを適用**
   ```bash
   patch -p1 < patches/requirements_secretmanager.patch
   ```
   - `google-cloud` メタを削除、`google-cloud-secret-manager>=2.20.0` を追加

2) **Cloud Run 環境変数の維持（Git Bash は MSYS_NO_PATHCONV=1）**
   ```bash
   MSYS_NO_PATHCONV=1 gcloud run services update "$SERVICE" --region "$REGION" \
     --set-env-vars=^:^BRIDGE_DIR=/app/bridge:SB_HEADLESS_MODE=new:SB_VIEWPORT=1360,1024:TEAM_NAME=Annulus
   ```

3) **明示タグで再デプロイ（必要時）→ /bridge_status → /enhanced_download → ログ確認**