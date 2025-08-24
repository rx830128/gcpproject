# 移行ノート（更新 2025-08-24 05:21）

## base_dir → bridge_dir
- `BridgeConfig.base_dir` は後方互換プロパティとして残置し、内部的に `bridge_dir` を返す。
- `/bridge_status` は `bridge_dir` が取得できない場合、`base_dir` も試行し、最後に既定パス（/app/bridge or /workspace/bridge）にフォールバック。

## Selenium 安定化
- `--headless=new --no-sandbox --disable-dev-shm-usage --window-size=1360,1024`
- SPA 待機: presence → visibility → clickable
- クリックは `scrollIntoView` → JS click でフォールバック

## Windows/Git Bash のパス変換
- `MSYS_NO_PATHCONV=1` を付けないと `/app/bridge` が `C:/Program Files/Git/app/bridge` に変換されることがある。
- Cloud Run 環境変数に誤った Windows パスが渡ると `accounts: {{}}` になるため注意。
