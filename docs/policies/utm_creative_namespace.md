# utm_creative パラメータ管理方針（名前空間分離方式）

*策定日: 2025年8月15日*

## 📋 基本方針

### 問題認識
- 異なる案件で同じutm_creativeパラメータ名が使用される（例：案件A、案件B両方で`25_cr-40f`）
- 従来の手動管理では案件増加・パラメータ増加に対応できない

### 解決方針
- **案件名 + パラメータ名** のペアで一意管理
- BigQueryから案件別パラメータを自動検出
- 手動メンテナンス不要の自動スケーリング

## 🔧 実装設計

### Phase 1: 緊急修正 ✅ 完了
- `extract_meta_data.py` のパラメータマッピング修正
- ロコヘルプ_FB ↔ 案件B の逆転問題解決

### Phase 2: 自動検出システム ✅ 完了
- `project_parameter_manager.py` 作成（自動検出クラス）
- BigQuery自動検出クエリ実装・テスト完了
- `extract_meta_data.py` 自動検出機能追加
- BigQueryビューの名前空間安全性更新

**現在の検出状況:**
- ロコヘルプ_FB: 22_cr-n系, 23_cr-n系 (7種類)
- 案件B: 25_cr系, 26-001_cr系, 27-001_cr系 (14種類)
- 自動検出機能: ✅ 正常動作確認済み

**自動検出クエリ例:**
```python
def auto_detect_by_project():
    sql = """
    SELECT 
        report_name,                    -- 案件名
        utm_creative,                   -- パラメータ名  
        COUNT(*) as usage_count,        -- 使用回数
        MAX(processed_at) as last_seen  -- 最終使用日
    FROM squadbeyond_reports
    WHERE utm_creative IS NOT NULL
    AND processed_at >= CURRENT_DATE() - 30
    GROUP BY report_name, utm_creative
    ORDER BY report_name, last_seen DESC
    """
```

### Phase 3: 完全自動化 🔄 準備完了
- 新案件追加時の自動パラメータ検出
- 新パラメータ出現時の自動システム更新
- 異常値・重複検知アラート

## 🎯 期待効果

**スケーラビリティ:**
- 案件数：1 → 100案件でも自動対応
- パラメータ数：各案件1000個でも自動管理

**安全性:**
- 案件間データ混在防止
- 名前空間分離による正確な分析

**運用性:**
- 手動メンテナンス作業ゼロ
- 新案件・新パラメータの即座対応

## 📝 実装ルール

1. **全てのutm_creative処理**は案件名とセットで行う
2. **BigQuery分析**は `WHERE report_name = '案件名'` を必須とする  
3. **新パラメータ検出**は直近30日データから自動実行
4. **手動設定ファイル**は段階的に自動検出に置換

**この方針により、案件・パラメータの無制限スケーリングを実現する。**