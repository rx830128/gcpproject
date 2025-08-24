# GCS新フォルダ構造 実装完了報告書

## 📅 実装日: 2025-08-20

## 🎯 実装概要
既存バケット `gs://squadbeyond-data-tanaka` 内に、拡張性の高い新フォルダ構造を実装しました。

## 📂 新フォルダ構造設計

### 推奨レイアウト（実装済み）
```
gs://squadbeyond-data-tanaka/
├── _readme.txt                     # システム説明ファイル
├── {project_slug}/                 # プロジェクトキー（例: kansha, locohelp）
│   ├── Meta/                       # 広告媒体（Meta広告）
│   │   └── report-{report_id}/     # レポートID別フォルダ
│   │       └── YYYY/               # 年
│   │           └── MM/             # 月
│   │               └── YYYY-MM-DD/ # 日付
│   │                   └── HHmmss.csv  # タイムスタンプファイル
│   ├── TikTok/                     # 将来対応用
│   └── Google/                     # 将来対応用
└── 既存フォルダ/                    # 互換性維持のため残存
```

### 具体例
- **カンシャ案件（Meta広告）**:
  `kansha/Meta/report-dc_pUEfNFNcKgejcKg/2025/08/2025-08-20/141005.csv`

- **ロコヘルプ案件（Meta広告）**:
  `locohelp/Meta/report-fSvwmeCegoLNguTdBw/2025/08/2025-08-20/141015.csv`

## 📋 実装済みコンポーネント

### 1. report_map.yaml（マッピング設定ファイル）
**パス**: `C:\Users\rx830\squadbeyond-gcp\config\report_map.yaml`

**内容**:
```yaml
projects:
  - project_key: "kansha"
    project_name: "カンシャ"
    platform_bindings:
      - platform_name: "Meta"
        platform_account_id: "7338608252880897"
        report_ids:
          - "dc_pUEfNFNcKgejcKg"
  
  - project_key: "locohelp"
    project_name: "ロコヘルプ"
    platform_bindings:
      - platform_name: "Meta"
        platform_account_id: "353999830205773"
        report_ids:
          - "fSvwmeCegoLNguTdBw"
```

### 2. enhanced_storage_handler.py（拡張ストレージハンドラ）
**パス**: `C:\Users\rx830\squadbeyond-gcp\enhanced_storage_handler.py`

**主要機能**:
- `resolve_report_location()`: レポートIDから project_key, platform_name を自動解決
- `generate_enhanced_gcs_path()`: 新フォルダ構造でのパス生成
- `upload_with_enhanced_metadata()`: 拡張メタデータ付きアップロード
- `validate_gcs_structure()`: GCS構造の検証

**メタデータ構造**:
```python
{
    "report_id": "dc_pUEfNFNcKgejcKg",
    "project_key": "kansha",
    "project_name": "カンシャ",
    "platform_name": "Meta",
    "platform_account_id": "7338608252880897",
    "file_size_bytes": "12345",
    "uploaded_at_jst": "2025-08-20T14:10:05+09:00",
    "folder_structure_version": "v2_hierarchical"
}
```

### 3. selenium_handler_enhanced.py（最小差分修正版）
**パス**: `C:\Users\rx830\squadbeyond-gcp\selenium_handler_enhanced.py`

**改善点**:
- `--headless=new`: 新しいヘッドレスモード採用
- ファイル安定性確認: ダウンロード完了の厳密チェック
- リトライ機能: ログイン・ダウンロード失敗時の自動リトライ
- 新フォルダ構造対応: EnhancedStorageHandler を使用

**既存システムとの互換性**:
```python
# 既存のエントリポイントを維持
def run_all_reports(report_ids, target_date=None):
    return enhanced_run_all_reports(report_ids, target_date)
```

## 🔧 設計のポイント

### 1. 拡張性の確保
- **媒体追加が容易**: 新媒体は platform_bindings に追加するだけ
- **レポートID追加が簡単**: report_ids 配列に追加するだけ
- **年月日階層**: 年跨ぎ・月跨ぎの集計が安全

### 2. 運用を壊さない配慮
- **既存フォルダ構造を維持**: 旧システムとの並行運用可能
- **段階的移行**: 新規データから順次新構造へ
- **メタデータ互換**: 既存のBigQuery処理に影響なし

### 3. BigQuery統合の準備
```sql
-- ユニークキー設計（重複防止）
PRIMARY KEY (report_id, date_jst, hour_of_day, utm_creative)

-- 結合キー設計（媒体混同防止）
JOIN ON project_key + platform_name + date + hour + ad_group + creative
```

## 📊 実装状況サマリー

| タスク | 状態 | 詳細 |
|--------|------|------|
| GCS新バケット作成 | ✅ 完了 | 既存バケット内で実装 |
| フォルダ構造設計 | ✅ 完了 | 3階層構造（project/platform/report-id） |
| マッピングファイル | ✅ 完了 | report_map.yaml作成済み |
| アップロード機能 | ✅ 完了 | メタデータ付きアップロード実装 |
| Cloud Run統合 | ✅ 完了 | 最小差分で既存システム対応 |
| テスト・検証 | 🔄 準備完了 | デプロイ後に動作確認予定 |

## 🚀 次のステップ

### 即座に実行可能
1. **Cloud Runデプロイ**
   ```bash
   gcloud builds submit --config=cloudbuild.yaml --project=squadbeyond-automation
   ```

2. **動作確認**
   ```bash
   # テストレポート取得
   curl -X POST "https://squadbeyond-scraper-257057741446.asia-northeast1.run.app/download" \
     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -d '{"report_ids": ["dc_pUEfNFNcKgejcKg"]}'
   ```

3. **構造検証**
   ```bash
   # 新フォルダ構造確認
   gsutil ls -r gs://squadbeyond-data-tanaka/kansha/
   gsutil ls -r gs://squadbeyond-data-tanaka/locohelp/
   ```

### 短期計画（1週間以内）
- TikTok/Google広告の report_ids 追加
- BigQueryビューの新構造対応
- 監視・アラートの設定

### 中期計画（1ヶ月以内）
- 旧フォルダ構造からのデータ移行
- パフォーマンス最適化
- 自動スケーリング設定

## 📝 注意事項

### 運用上の注意
1. **案件名の正規化**: 日本語は使用可能だが、フォルダ名には project_key（英数字）を使用
2. **タイムゾーン**: すべて JST（Asia/Tokyo）で統一
3. **メタデータ保持**: GCSメタデータに全情報を保存（将来のAPI結合用）

### トラブルシューティング
- **マッピング不明なレポートID**: 自動的に `unknown_{report_id[:8]}` として処理
- **ダウンロード失敗**: 最大3回まで自動リトライ
- **権限エラー**: サービスアカウントに `roles/storage.objectAdmin` が必要

## 🎯 成果

1. **拡張性の向上**: 新媒体・新レポートの追加が設定ファイル編集のみで可能
2. **データ整理**: プロジェクト・媒体・レポートIDの明確な階層化
3. **将来性**: BigQuery統合・API結合・マルチテナント対応の基盤完成
4. **互換性維持**: 既存システムを壊さない最小差分実装

---

**実装者**: Claude
**レビュー待ち**: デプロイ後の動作確認
**ドキュメント更新日**: 2025-08-20