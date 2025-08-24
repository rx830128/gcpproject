# CONFIG スキーマ（更新 2025-08-24）

## accounts.yaml
```yaml
accounts:
  <account_id>:
    base_url: https://app.squadbeyond.com
    login_email_secret: projects/<PROJECT_ID>/secrets/<SECRET_NAME>/versions/latest
    password_secret:     projects/<PROJECT_ID>/secrets/<SECRET_NAME>/versions/latest
    team_name: "Annulus"
    active: true
```

## report_registry.yaml
```yaml
reports:
  - report_id: SMARTNEWS_XXXX
    project_id: hizakoshi
    account_id: squad_themarch01
    active: true
```
