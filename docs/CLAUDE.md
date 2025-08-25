# CLAUDE.md — ClaudeCode 運用原則

このリポジトリに対し ClaudeCode 経由で変更・コミットする際の必須ルール。

## 原則
1. **生の秘密情報をコミット禁止**。Secret 名だけを扱う
2. ブランチ名: `feat/...`, `fix/...`, `docs/...`, `chore/...`
3. PR タイトルは日本語OK。変更の意図と影響範囲を明確化
4. ビルドは `cloudbuild.docker.yaml` を使い **必ず Artifact Registry に tag を push**
5. 破壊的変更は PR レビュー必須。`/bridge_status` が `operational` になることを確認
6. Cloud Run の環境変数（`BRIDGE_DIR`, `TZ`）は変更前後をログに記録

## よく使うタスク（ClaudeCodeへ発行する指示例）
- **ドキュメント更新 & コミット**
  - 追加/更新ファイルを列挙
  - `git add -A && git commit -m "docs: ..." && git push -u origin <branch>`
- **レポート登録の追加**
  - `bridge/report_registry.yaml` を schema 遵守で編集
  - `tools/validate_registry.py` が通ること（ローカル実行でも可）
- **ビルド → デプロイ**
  - `cloudbuild.docker.yaml` で submit（`_IMAGE=<TAG>`）
  - 成果タグを Cloud Run へ `gcloud run deploy --image <TAG>`
- **検証**
  - `/bridge_status` → `operational`
  - `/enhanced_download` → ログで gs:// 保存確認