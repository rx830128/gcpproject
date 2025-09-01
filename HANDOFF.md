# Handoff Documentation

### Stability Hold（2025‑09‑01）
- 現在の安定線: 00132-vfs (v1.0.3) / stable=100%
- 変更禁止: 本番トラフィック配分・サービス設定は維持
- 検証は **canary=0%** でのみ実施し、5本スモーク (OK≥4/5 & p95≤300s) を基準に段階切替
- 参考コマンド: `scripts/deploy_same_image_with_mem.sh`, `scripts/smoke_hizakoshi.sh`
- 直近の失敗傾向: 新リビジョンでChromeクラッシュ（headless new/old/none 共通）
- 当面方針: 00132-vfs を維持しつつ、canaryでのみ Xvfb / Chrome pin / mem 調整を試行