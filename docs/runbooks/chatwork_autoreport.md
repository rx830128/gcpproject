# 🔔 Chatwork自動レポート送信（2025年8月16日実装）

## 概要
毎時10分にChatworkへ統合レポートを自動送信。データ統合完了後、3階層のレポートを見やすい形式で配信。

## 送信先設定
- **ルームID**: 407558333
- **APIトークン**: 環境変数`CHATWORK_API_TOKEN`で管理
- **送信時刻**: 毎時10分（JST）

## レポート構成
1. **案件別サマリー**
   - 費用、表示回数、CTR
   - CV数、CPA
   - FVSR、OAR

2. **広告グループ別TOP10**
   - 案件別に上位10グループ
   - 費用、CV、CPA表示

3. **CV獲得クリエイティブ**
   - CV獲得があったクリエイティブのみ
   - 案件/広告グループ_クリエイティブ形式
   - CV数、CPA表示

## 実装ファイル
- `chatwork_reporter.py`: レポート生成・送信モジュール
- `/chatwork_report`: Cloud Runエンドポイント
- `chatwork-hourly-report`: Cloud Schedulerジョブ

## 特殊処理
- **深夜0時対応**: 当日データがない場合は前日23時データを使用
- **データ欠損対応**: integrated_hourly_analysis_safeビューから取得
- **エラー通知**: 送信失敗時はCloud Loggingに記録

## 手動実行コマンド
```bash
# Cloud Scheduler経由
gcloud scheduler jobs run chatwork-hourly-report --location=asia-northeast1

# 直接API呼び出し
curl -X POST "https://squadbeyond-scraper-257057741446.asia-northeast1.run.app/chatwork_report" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" -d "{}"
```

## ⚠️ 既知の問題（2025年8月16日）

### 問題: report_nameがNoneと表示される

**症状:**
- Meta広告データの案件名が「None」と表示
- 案件B、ロコヘルプ_FBの費用が0円
- 広告グループが案件別に分類されない

**原因:**
- integrated_hourly_analysis_safeビューでMeta広告データにreport_nameがない
- Meta広告とSquadBeyondのJOINが不完全

**修正済みだが未デプロイ:**
- chatwork_reporter.py: 案件名マッピングロジック追加
  - cr-n% → ロコヘルプ_FB
  - cr-% → 案件B
- 全指標表示対応済み

**必要な作業:**
1. chatwork_reporter.pyのデプロイ完了確認
2. integrated_hourly_analysis_safeビューの改修検討
   - Meta広告データにreport_name追加
   - またはJOIN条件の見直し

**暫定対応:**
手動でレポート内容を修正して送信

**確認コマンド:**
```bash
# デプロイ状況確認
gcloud run services describe squadbeyond-scraper --region=asia-northeast1 --format="value(status.latestReadyRevisionName)"

# 手動テスト
curl -X POST "https://squadbeyond-scraper-257057741446.asia-northeast1.run.app/chatwork_report" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" -d "{}"
```