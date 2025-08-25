# META — Secrets Status

- Secrets:
  - `SQUAD_THEMARCH01_EMAIL` → email 文字列
  - `SQUAD_THEMARCH01_PASSWORD` → password 文字列
- Access:
  - Cloud Run 実行 SA に `roles/secretmanager.secretAccessor`
- 注意:
  - 生値はリポジトリに書かない