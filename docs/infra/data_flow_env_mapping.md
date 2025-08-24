# 🔥 SquadBeyondデータ統合システム完全理解（2025年8月18日確定）

## 🎯 基本原則の確定

**✅ 正しい基本原則:**
```
report_nameはSquadBeyondレポートIDから env.yaml で判別する
パラメータ内容（cr-n、cr-数字）での案件判定は使用しない
```

**❌ 間違った理解:**
```
パラメータ内容で案件を判定する
SquadBeyond内部で案件名が設定される
```

## 📊 完全なデータフロー

### Step 1: SquadBeyond SaaS内部
```
SquadBeyond社のサーバー:
├── ユーザーアクセス検知（utm_creative=25_cr-46）
├── パラメータのみ記録（案件名は記録しない）
└── レポートID別にデータ蓄積
```

### Step 2: CSV出力・取得
```
SquadBeyond → レポートID別CSV生成
├── URL例: https://squadbeyond.com/reports/fSvwmeCegoLNguTdBw/csv
├── CSV内容: パラメータ情報のみ（案件名なし）
└── Cloud RunがレポートID別にCSVダウンロード
```

### Step 3: Cloud Run処理（案件名判別）
```
CSV取得処理:
├── ダウンロードURL確認: /reports/fSvwmeCegoLNguTdBw/csv
├── レポートID抽出: fSvwmeCegoLNguTdBw
├── env.yaml参照: fSvwmeCegoLNguTdBw=案件B
└── BigQuery投入: パラメータ + 案件名「案件B」
```

### Step 4: Meta広告データ統合
```
BigQuery統合処理:
├── 統合キー: 広告グループ_クリエイティブNo（例：25_cr-46）
├── 案件名: env.yamlで判別した案件名
└── 結合: SquadBeyondデータ + Meta広告データ
```

## 🔧 案件判別設定（env.yaml）

```yaml
# レポートID → 案件名マッピング（明示的設定必須）
REPORT_IDS: fSvwmeCegoLNguTdBw,dc_pUEfNFNcKgejcKg
REPORT_LABELS: dc_pUEfNFNcKgejcKg=ロコヘルプ_FB;fSvwmeCegoLNguTdBw=案件B
```

**現在の対応関係:**
| レポートID | 案件名 | パラメータ例 |
|-----------|--------|-------------|
| `dc_pUEfNFNcKgejcKg` | ロコヘルプ_FB | 25_cr-46, 27-001_cr-60 |
| `fSvwmeCegoLNguTdBw` | 案件B | 22_cr-n03, 23_cr-n10 |

## 🆕 新規案件追加手順（完全版）

**新規案件追加時の必要情報:**
- **SquadBeyondレポートID**（例: 新レポートID123456789）
- **Meta広告アカウントID**（例: 999888777666555）

**設定手順:**

1. **SquadBeyond設定（env.yaml）**
   ```yaml
   REPORT_IDS: fSvwmeCegoLNguTdBw,dc_pUEfNFNcKgejcKg,新レポートID123456789
   REPORT_LABELS: dc_pUEfNFNcKgejcKg=ロコヘルプ_FB;fSvwmeCegoLNguTdBw=案件B;新レポートID123456789=案件C
   ```

2. **Meta広告設定（コード修正必須）**
   ```python
   # meta_api_handler.py 内
   account_mapping = {
       '353999830205773': '案件B',
       '7338608252880897': 'ロコヘルプ_FB',
       '999888777666555': '案件C'  # 新Meta広告アカウントID追加
   }
   ```

3. **Cloud Runデプロイ（2回必要）**
   - env.yaml更新後: 1回目デプロイ
   - コード修正後: 2回目デプロイ

4. **動作確認**
   - BigQueryで新案件データ確認
   - 統合ビューでの表示確認

## 📋 指標計算の正確な理解

### 率（%）を表示する指標
```sql
FVER = AVG(fvser)  -- FV離脱率の平均（例：17.5%）
OAR = AVG(oar)     -- オファー到達率の平均（例：25.3%）
```

### 件数を計算する指標
```sql
FV離脱数 = SUM(ROUND(version_pv * fvser / 100, 2))  -- 実際の離脱件数
オファー到達数 = SUM(ROUND(version_pv * oar / 100, 2))  -- 実際の到達件数
```

### 単価計算
```sql
FV離脱単価 = cost / FV離脱数      -- 1件あたりの獲得費用
OA単価 = cost / オファー到達数    -- 1件あたりの獲得費用
```

## 🚨 データ参照時の絶対ルール

**✅ 2025年8月17日以降のデータのみ参照:**
```sql
WHERE date_jst >= '2025-08-17'
```

**理由**: 16日以前は案件名逆転問題があり、修正ロジックで複雑化しているため

## 🎯 統合システムの本質

**重要な理解:**
- **SquadBeyond**: パラメータのみ記録、案件名は記録しない
- **案件判別**: Cloud Run側でレポートIDから env.yaml を使って判別
- **統合キー**: 広告グループ_クリエイティブNo で Meta ↔ SquadBeyond を結合
- **スケーラビリティ**: 新パターン（cr-s等）も env.yaml 設定のみで対応可能

**このシステムにより、案件・パラメータの無制限スケーリングと正確なデータ統合を実現する。**