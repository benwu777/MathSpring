# 題庫題數計算規則

## 正式題庫總數

計算一到十二年級的正式題目總數時，**唯一依據是** `assets/questions/manifest.json` 的 `packs` 清單。

對 manifest 中每個 pack：

1. 讀取 `path` 指向的 JSON 檔。
2. 計算該檔 `questions` 陣列的長度。
3. 依 `levelStage` 加總到對應年級。

不要只用特定 topic 目錄的 glob（例如只列出 arithmetic、geometry、logic、mixed）；七到十二年級另有 `algebra`、`combinatorics`、`number_theory` 題包，漏列會造成少算。

## 不納入正式總數的資料

未在 manifest 中列出的 JSON 是舊資料或工作資料，不應混入正式年級總數。例：

- `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json`

若需要回報這類題包，請另列「舊題包／待處理題數」，不要與正式題庫加總混報。

## 目前基準（2026-08-26）

| 年級 | 題數 |
| --- | ---: |
| 1 | 153 |
| 2 | 154 |
| 3 | 161 |
| 4 | 155 |
| 5 | 167 |
| 6 | 170 |
| 7–12 | 各 150 |
| **總計** | **1,860** |

## 可重跑驗證

在專案根目錄執行：

```sh
ruby -rjson -e 'm=JSON.parse(File.read("assets/questions/manifest.json")); g=(1..12).to_h{|x|["grade#{x}",0]}; m.fetch("packs").each{|p| s=p["levelStage"]; next unless g.key?(s); g[s]+=(JSON.parse(File.read(p.fetch("path")))["questions"]||[]).size}; g.each{|k,v| puts "#{k}=#{v}"}; puts "total=#{g.values.sum}"'
```

再確認所有年級題庫 JSON 都被 manifest 收錄：

```sh
ruby -rjson -e 'all=Dir["assets/questions/**/*.json"].reject{|f|f.end_with?("manifest.json")}; listed=JSON.parse(File.read("assets/questions/manifest.json")).fetch("packs").map{|p|p.fetch("path")}; grade=all.select{|f|File.basename(f)=~/grade(?:[1-9]|1[0-2])_/}; puts "unlisted_grade_files=#{(grade-listed).size}"'
```

預期輸出為 `total=1860` 與 `unlisted_grade_files=0`；如題庫有新增或移除，以當次輸出為準並同步更新本文件的基準日期與表格。
