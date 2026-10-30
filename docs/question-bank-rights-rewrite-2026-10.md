# 官方競賽題改寫清單（2026-10）

最後更新：2026-10-30。分支：`develop`。

## 為什麼要改寫

題庫中這 283 題的 `source.type` 是 `official_reference`，內容幾乎照搬 IMC 台灣區與 MAA（AMC／AJHSME）的競賽原題（數字、情境相同，只翻成四語系），資料上也一直標著 `rightsStatus: needs_review`。公開可下載不等於可在付費 App 中重製與散布，畫面上還直接標示「出處：AMC 8 …」。送審前決定全部**實質改寫**，而不是申請授權或下架。

## 改寫規則

1. **保留**：題號（`id`）、年級、主題、子分類、難度、題型（選擇／填數）、`c:`／`m:` 標籤——也就是「考的觀念與程度」。
2. **全部換掉**：數字、情境、角色、措辭與問法；答案因此改變，必須重新計算。選擇題的誘答依新數字重寫，長度與具體程度要跟正解相當。
3. **不得**只換數字或只換故事後保留原句型；改寫後的題目放在原題旁邊，應該看不出是同一題的翻譯或換皮。
4. 詳解依新題目從頭推導，四語系同步；遵守既有驗證器（答案值須出現在詳解、簡中用語、選項長度等）。
5. 附圖題依新數字調整 `figure` 參數，並用 `scripts/dump_figure_previews.py` 目視確認圖與題意一致。
6. `source` 改為 `{"type": "rewritten_olympiad_style", "name": "MathSpring 改寫題", "reference": "考的題型", "notes": "設計依據"}`，和題庫其他改寫題同格式；**移除** `contest`、`year`、`round`、`division`、`problemNumber`、`displayText`、`sourceUrl`、`rightsStatus` 等可追溯原題的欄位，`reference`／`notes` 也不得寫競賽名稱、年份、題號或網址。畫面上因此不再顯示出處。驗證器 `check_source_provenance` 會擋回歸。
7. 原題來源**只保留在這份文件**（不會打包進 App），作為內部追溯紀錄。
8. 改寫後要跑完題庫既有閘門：`scripts/validate_question_packs.py`、相似度與模板掃描（避免撞到庫內其他題）、`flutter test`。

## 統計

| 來源 | 題數 |
|---|---|
| 第16屆IMC國際數學競賽台灣區初賽 | 106 |
| IMC Taiwan | 80 |
| AMC 12 | 38 |
| AMC 10 | 24 |
| AMC 8 | 22 |
| 第二十一屆國際數學競賽台灣區複賽 | 10 |
| AJHSME | 3 |
| **合計** | **283** |

| 年級 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 題數 | 19 | 20 | 20 | 18 | 15 | 24 | 29 | 28 | 27 | 29 | 26 | 28 |

附圖題 28 題；選擇題 185 題、填數題 98 題。

## 題目清單

「原題」欄是改寫前的繁中題幹（截斷），「原答案」是改寫前的正解。狀態：`待改寫` → `已改寫`。


### 1 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 1 | `arithmetic_grade1_foundation_051` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 3](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 5 個連續偶數的和是 90。這 5 個偶數中，最大和最小相差多少？ | 已改寫 |
| 2 | `arithmetic_grade1_foundation_052` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 5](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 依規律排成一列：1，4，8，11，22，25，50，53，□，△。請問 □ 和 △ 應該是哪兩個數？ | 已改寫 |
| 3 | `arithmetic_grade1_foundation_053` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 6](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 同一個數列：1，4，8，11，22，25，50，53，106，109，……。從第幾個數開始，會第一次出現百位數是 2 的三位數？ | 已改寫 |
| 4 | `arithmetic_grade1_foundation_054` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 7](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 已知西元 2012 年是閏年，而且題目只用「每 4 年一閏」這個規則來判斷。下面哪一年也會是閏年？ | 已改寫 |
| 5 | `arithmetic_grade1_foundation_055` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 8](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 虹虹依序說 5、10、15……；伶伶依序說 7、14、21……；玟玟依序說 3、6、9、12……。三個人第一次會同時說到哪一個數？ | 已改寫 |
| 6 | `arithmetic_grade1_foundation_056` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 9](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 有一座古董鐘，只要分針指到 6 就敲 1 下。一天共有 24 小時，請問這座鐘一整天會因為分針指到 6 而敲幾下？ | 已改寫 |
| 7 | `arithmetic_grade1_foundation_057` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 10](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 同一座鐘除了分針指到 6 會敲 1 下之外，還會在奇數整點時敲和鐘點相同的下數：1 點敲 1 下、3 點敲 3 下、5 點敲 5 下、7 點… | 已改寫 |
| 8 | `arithmetic_grade1_foundation_058` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 2](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 小玉說：「我跑 100 公尺要 11 秒。」小雄說：「我跑操場一圈 400 公尺要 50 秒。」不考慮其他因素，誰跑得比較快？ | 已改寫 |
| 9 | `arithmetic_grade1_foundation_059` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 3](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 填數 |  | {'type': 'integer', 'value': '10'} | 桌上有紅、橙、黃、綠、藍 5 種顏色的彩色筆。每次只能拿 2 枝，而且不分順序。請問一共有幾種不同拿法？ | 已改寫 |
| 10 | `arithmetic_grade1_foundation_060` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 5](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 填數 |  | {'type': 'integer', 'value': '3380'} | 巧虎舞台劇票價如下：成人票 550 元，兒童票（6 歲到 12 歲）400 元，幼兒票（3 歲到 5 歲）380 元，敬老票 300 元。爸… | 已改寫 |
| 11 | `arithmetic_grade1_foundation_061` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 6](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 填數 |  | {'type': 'integer', 'value': '131'} | 先找出 10 以內比 3 大的 3 個連續奇數，再把 20 以內所有的偶數也加進來。這些數全部加起來是多少？ | 已改寫 |
| 12 | `arithmetic_grade1_foundation_062` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，挑戰 3](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 媽媽的零錢包裡有 1 元、5 元、10 元、50 元四種硬幣，總共 253 元。已知 50 元硬幣有 2 個，5 元硬幣有 9 個，而且 1… | 已改寫 |
| 13 | `logic_grade1_foundation_041` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 1](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 快樂路一段的一側只排奇數門牌，依序是 301、303、305、307、309；另一側只排偶數門牌，依序是 300、302、304、306、3… | 已改寫 |
| 14 | `logic_grade1_foundation_042` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 2](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 沿用同一條街的排法：301、303、305、307、309 在同一側；300、302、304、306、308、310 在另一側。四個地點的門… | 已改寫 |
| 15 | `logic_grade1_foundation_043` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，選擇 4](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 已知 A×B = C×D，四個數都是正數，而且 A 比 C 大。那麼 B 和 D 的大小關係是什麼？ | 已改寫 |
| 16 | `logic_grade1_foundation_044` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 4](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 過年時三兄弟都拿到紅包。大哥說：「我的錢不少於 900 元，不大於 1000 元，而且是四位數。」二哥說：「我的錢是偶數，而且快要 1000… | 已改寫 |
| 17 | `logic_grade1_foundation_045` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 8(1)](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 分類帽把所有人分成 A、B、C、D 四隊：抽到 1 號進 A 隊，2 號進 B 隊，3 號進 C 隊，4 號進 D 隊，5 號又回到 A 隊… | 已改寫 |
| 18 | `logic_grade1_foundation_046` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 8(3)](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 沿用同一個分隊規則：A、B、C、D 每 4 個號碼循環一次。榮恩抽到 21 號，希望哈利和他同一隊。現在只剩下 24、29、40、34 四個… | 已改寫 |
| 19 | `logic_grade1_foundation_047` | [第16屆IMC國際數學競賽台灣區初賽，國小一年級，計算 8(2)](https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 分類帽把號碼依序分到 A、B、C、D 四隊：1 號到 A 隊，2 號到 B 隊，3 號到 C 隊，4 號到 D 隊，之後每 4 個號碼循環一… | 已改寫 |

### 2 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 20 | `arithmetic_grade2_foundation_051` | [第16屆IMC台灣區初賽國小二年級 選擇 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 8 個 4 比 6 個 4 多了幾個 4？ | 已改寫 |
| 21 | `arithmetic_grade2_foundation_052` | [第16屆IMC台灣區初賽國小二年級 選擇 2](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 被加數 + 加數 = 10（被加數和加數都是 0 到 10 的整數），而且被加數 > 加數，符合這樣條件的算式有幾組？ | 已改寫 |
| 22 | `arithmetic_grade2_foundation_053` | [第16屆IMC台灣區初賽國小二年級 選擇 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 從 75 數到 100，共有幾個偶數？ | 已改寫 |
| 23 | `arithmetic_grade2_foundation_054` | [第16屆IMC台灣區初賽國小二年級 選擇 4](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 98 − □ = 18，則 □ + 1 = ? | 已改寫 |
| 24 | `arithmetic_grade2_foundation_055` | [第16屆IMC台灣區初賽國小二年級 選擇 5](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 120→103→□→□→52→35，空格內該填入多少？ | 已改寫 |
| 25 | `arithmetic_grade2_foundation_056` | [第16屆IMC台灣區初賽國小二年級 選擇 6](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 弟弟買 2 枝鉛筆花了 45 元，如果要買 6 枝鉛筆要花多少元？ | 已改寫 |
| 26 | `arithmetic_grade2_foundation_057` | [第16屆IMC台灣區初賽國小二年級 選擇 7](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 1+2+3+4+5+6+7+8+9+10−55 = ? | 已改寫 |
| 27 | `arithmetic_grade2_foundation_058` | [第16屆IMC台灣區初賽國小二年級 選擇 10](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 冰店上午賣出 12 枝冰棒，下午比上午多賣出 4 枝，今天共賣出多少枝冰棒？ | 已改寫 |
| 28 | `arithmetic_grade2_foundation_059` | [第16屆IMC台灣區初賽國小二年級 選擇 11](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 174 < □ < 202，下列哪一個數字不能填入空格內？ | 已改寫 |
| 29 | `arithmetic_grade2_foundation_060` | [第16屆IMC台灣區初賽國小二年級 選擇 14](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 「11 + 21 + 31」最接近下列哪一個數字？ | 已改寫 |
| 30 | `arithmetic_grade2_foundation_061` | [第16屆IMC台灣區初賽國小二年級 選擇 15](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 媽媽給你 3 個五十元硬幣，你花掉了 105 元後，還剩下多少元？ | 已改寫 |
| 31 | `arithmetic_grade2_foundation_062` | [第16屆IMC台灣區初賽國小二年級 選擇 17](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 故事書和漫畫書共有 40 本，故事書比漫畫書多 6 本。漫畫書有多少本？ | 已改寫 |
| 32 | `arithmetic_grade2_foundation_063` | [第16屆IMC台灣區初賽國小二年級 選擇 19](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 下面哪一個東西的容量最大？ | 已改寫 |
| 33 | `arithmetic_grade2_foundation_064` | [第16屆IMC台灣區初賽國小二年級 選擇 20](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | ★ + ★ + □ = 39，★ + □ = 25，則 ★ − □ = ? | 已改寫 |
| 34 | `arithmetic_grade2_foundation_065` | [第16屆IMC台灣區初賽國小二年級 選擇 21](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 已知 4⊕3 = 4+4+4 = 12，8⊕2 = 8+8 = 16，7⊕5 = 7+7+7+7+7 = 35，則 3⊕8 = ? | 已改寫 |
| 35 | `arithmetic_grade2_foundation_066` | [第16屆IMC台灣區初賽國小二年級 選擇 23](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 牆上掛著一本日曆，今天是 3 月 1 日，再過一星期就是媽媽的生日。請問媽媽的生日是幾月幾日？ | 已改寫 |
| 36 | `arithmetic_grade2_foundation_067` | [第16屆IMC台灣區初賽國小二年級 選擇 24](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 將 19 顆彈珠，每 3 顆裝一袋，至少要裝幾袋才夠？ | 已改寫 |
| 37 | `arithmetic_grade2_foundation_068` | [第16屆IMC台灣區初賽國小二年級 選擇 25](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 媽媽分糖果，哥哥拿到 15 顆糖果，妹妹拿得比哥哥多 12 顆，弟弟拿得比妹妹少 8 顆，三人共分到多少顆糖果？ | 已改寫 |
| 38 | `arithmetic_grade2_foundation_069` | [第16屆IMC台灣區初賽國小二年級 計算 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 填數 |  | {'type': 'integer', 'value': '18'} | 有一組減法算式，被減數、減數及差數的和剛好是 36。求被減數是多少？ | 已改寫 |
| 39 | `logic_grade2_foundation_041` | [第16屆IMC台灣區初賽國小二年級 計算 2](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD2%E5%B9%B4%E7%B4%9A.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 有三人在聊天：阿明說「今天是 11 月 3 日，星期日」；佑佑說「後天是我的生日」；小德說「我的生日過 8 天是佑佑的生日」。請問下列哪一個… | 已改寫 |

### 3 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 40 | `arithmetic_grade3_foundation_054` | [第16屆IMC台灣區初賽國小三年級 選擇 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | ★ + ★ = ◎，且 ★×◎ = 98。請問 ◎ − ★ = ? | 已改寫 |
| 41 | `arithmetic_grade3_foundation_055` | [第16屆IMC台灣區初賽國小三年級 選擇 2](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 小萍 2019 年去參加 3 天 2 夜露營活動，回家後，她將這三天的日曆撕下來，並把這 3 天日曆上的日數相加，和數剛好等於 31。請問她… | 已改寫 |
| 42 | `arithmetic_grade3_foundation_056` | [第16屆IMC台灣區初賽國小三年級 選擇 4](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | A 和 B 都是 1 到 9 的數字，且滿足 (A+B)÷B = 4。請問 A×B 不可能是哪一個？ | 已改寫 |
| 43 | `arithmetic_grade3_foundation_057` | [第16屆IMC台灣區初賽國小三年級 選擇 5](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 一支冰淇淋賣 35 元，一瓶可樂比一支冰淇淋少 12 元。促銷期間兩種商品合賣 50 元。如果在促銷期間購買這兩種商品，可以省下多少元？ | 已改寫 |
| 44 | `arithmetic_grade3_foundation_058` | [第16屆IMC台灣區初賽國小三年級 選擇 6](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 時鐘上分針指著數字 A，時針在數字 B 和數字 C 之間，且 A = B + C。下列哪一個時間不可能發生？ | 已改寫 |
| 45 | `arithmetic_grade3_foundation_059` | [第16屆IMC台灣區初賽國小三年級 選擇 9](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 爸爸用 4 公尺的繩子測量柱子的周圍長。繞了柱子 2 圈後，繩子還多出 30 公分。請問柱子的周圍長是多少公分？ | 已改寫 |
| 46 | `arithmetic_grade3_foundation_060` | [第16屆IMC台灣區初賽國小三年級 選擇 10](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 兩個數的差是 199。把較小的數加上 50，再把較大的數減去 50，新的差是多少？ | 已改寫 |
| 47 | `arithmetic_grade3_foundation_061` | [第16屆IMC台灣區初賽國小三年級 選擇 11](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 元元今年 3 月 7 日到新加坡出差，預計 12 週後回台灣。她回到台灣的日期是幾月幾日？ | 已改寫 |
| 48 | `arithmetic_grade3_foundation_062` | [第16屆IMC台灣區初賽國小三年級 選擇 12](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 6×A + B = 100，A 和 B 都是大於 0 的整數。A+B 的最小值是多少？ | 已改寫 |
| 49 | `arithmetic_grade3_foundation_063` | [第16屆IMC台灣區初賽國小三年級 選擇 15](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 三位數的各位數字和是 24，符合條件的三位數共有幾個？ | 已改寫 |
| 50 | `arithmetic_grade3_foundation_064` | [第16屆IMC台灣區初賽國小三年級 選擇 16](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 6 個千、28 個百、29 個十和 30 個一，合起來是多少？ | 已改寫 |
| 51 | `arithmetic_grade3_foundation_065` | [第16屆IMC台灣區初賽國小三年級 選擇 17](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 倉庫有 425 顆蘋果，每 12 顆裝成一箱，最後一箱還差多少顆蘋果才能裝滿？ | 已改寫 |
| 52 | `arithmetic_grade3_foundation_066` | [第16屆IMC台灣區初賽國小三年級 選擇 18](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | A、B、C 是正整數，且 A÷7 = B …… C，並且 A+B+C = 10。請問 A×C = ? | 已改寫 |
| 53 | `arithmetic_grade3_foundation_067` | [第16屆IMC台灣區初賽國小三年級 選擇 19](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 659→665→◆→□，求 ◆×2 + □ = ? | 已改寫 |
| 54 | `arithmetic_grade3_foundation_068` | [第16屆IMC台灣區初賽國小三年級 選擇 21](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 快樂綠茶店促銷：買綠茶 5 杯就送 1 杯。張叔叔拿到 15 杯綠茶，共花 260 元。請問一杯綠茶原價多少元？ | 已改寫 |
| 55 | `arithmetic_grade3_foundation_069` | [第16屆IMC台灣區初賽國小三年級 選擇 22](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 從 103 數到 179，共有多少個整數？ | 已改寫 |
| 56 | `arithmetic_grade3_foundation_070` | [第16屆IMC台灣區初賽國小三年級 選擇 24](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 13×15 + (144−6)×4 = ? | 已改寫 |
| 57 | `arithmetic_grade3_foundation_071` | [第16屆IMC台灣區初賽國小三年級 選擇 25](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | △+△+△+△ = 18，請問 △+△+△+△+△+△ = ? | 已改寫 |
| 58 | `arithmetic_grade3_foundation_072` | [第16屆IMC台灣區初賽國小三年級 計算 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 填數 |  | {'type': 'integer', 'value': '55'} | 在農場裡，山羊比鴨子多 15 隻，全部動物的腳一共有 180 隻。請問農場裡共有多少隻動物？ | 已改寫 |
| 59 | `logic_grade3_foundation_043` | [第16屆IMC台灣區初賽國小三年級 選擇 23](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD3%E5%B9%B4%E7%B4%9A0830.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | A、B、C 都是正整數，且 A+40 = B−32 = C×2 = 100。請問 A、B、C 的大小順序為何？ | 已改寫 |

### 4 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 60 | `arithmetic_grade4_foundation_051` | [第16屆IMC台灣區初賽國小四年級 選擇 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 定義 5³ = 5×5×5，7² = 7×7，求 14² + 6⁴ = ? | 已改寫 |
| 61 | `arithmetic_grade4_foundation_052` | [第16屆IMC台灣區初賽國小四年級 選擇 2](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 爸爸晚上 8 時出門工作，隔天早上 9 時回家。他一共工作了多久？ | 已改寫 |
| 62 | `arithmetic_grade4_foundation_053` | [第16屆IMC台灣區初賽國小四年級 選擇 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 12.8 + ★ - 0.4 = 15.2 - ★，求 ★ = ? | 已改寫 |
| 63 | `arithmetic_grade4_foundation_054` | [第16屆IMC台灣區初賽國小四年級 選擇 4](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 2019 ÷ 6□ = □2……□，空格內都是相同的數字。那麼 2019 ÷ □□ 的餘數是多少？ | 已改寫 |
| 64 | `arithmetic_grade4_foundation_055` | [第16屆IMC台灣區初賽國小四年級 選擇 5](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 桌上原有 3/5 個披薩，John 吃了一些後，還剩下 3/10 個披薩。John 吃了多少個披薩？ | 已改寫 |
| 65 | `arithmetic_grade4_foundation_056` | [第16屆IMC台灣區初賽國小四年級 選擇 7](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 數字「40000400004」應讀作什麼？ | 已改寫 |
| 66 | `arithmetic_grade4_foundation_057` | [第16屆IMC台灣區初賽國小四年級 選擇 9](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 現在時間是 7 時 15 分，再過 15 分鐘後，時針與分針的最小夾角是多少度？ | 已改寫 |
| 67 | `arithmetic_grade4_foundation_058` | [第16屆IMC台灣區初賽國小四年級 選擇 11](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 2.5 日與 2 日 5 時相差多少時間？ | 已改寫 |
| 68 | `arithmetic_grade4_foundation_059` | [第16屆IMC台灣區初賽國小四年級 選擇 12](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | ★+★+★=◎，且 ★×◎=147，求 ◎−★ = ? | 已改寫 |
| 69 | `arithmetic_grade4_foundation_060` | [第16屆IMC台灣區初賽國小四年級 選擇 13](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | A、B 都是 1 到 9 的數字，且 (A+2B)÷B = 7，則 A×B = ? | 已改寫 |
| 70 | `arithmetic_grade4_foundation_064` | [第16屆IMC台灣區初賽國小四年級 選擇 17](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 一個長方形，長邊剪去 8 公分後面積減少 64 平方公分；接著在剪過的長方形上，短邊再剪去 5 公分，面積又減少 50 平方公分。原來的面積… | 已改寫 |
| 71 | `arithmetic_grade4_foundation_065` | [第16屆IMC台灣區初賽國小四年級 選擇 18](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 甲、乙、丙共有 2019 元，甲比乙的 4 倍多 67 元，乙比丙的 4 倍多 67 元。甲和丙相差多少元？ | 已改寫 |
| 72 | `arithmetic_grade4_foundation_066` | [第16屆IMC台灣區初賽國小四年級 選擇 19](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 工人每天可做 6 件上衣或 8 件褲子。1 件上衣加 1 件褲子算 1 套服裝。現在有 84 名工人，每天最多可生產多少套？ | 已改寫 |
| 73 | `arithmetic_grade4_foundation_067` | [第16屆IMC台灣區初賽國小四年級 選擇 20](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 98.72 = 90 + 8 + 7/10 + 1/□。缺少的數是多少？ | 已改寫 |
| 74 | `arithmetic_grade4_foundation_068` | [第16屆IMC台灣區初賽國小四年級 選擇 21](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 甲=4.2 公升，乙=4 公升 2 分公升，丙=4 公升 200 毫公升。三者大小關係為何？ | 已改寫 |
| 75 | `arithmetic_grade4_foundation_069` | [第16屆IMC台灣區初賽國小四年級 選擇 23](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 671×◆=■，且 2×◆+■=2019。求 ■−◆ = ? | 已改寫 |
| 76 | `arithmetic_grade4_foundation_070` | [第16屆IMC台灣區初賽國小四年級 選擇 24](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 1 個平角 + 1 個周角 − 1 個直角 = 45° × □，求 □ = ? | 已改寫 |
| 77 | `arithmetic_grade4_foundation_071` | [第16屆IMC台灣區初賽國小四年級 選擇 25](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD4%E5%B9%B4%E7%B4%9A%200926-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 定義 4ρ5 = 4×5−5 = 15，7ρ3 = 7×3−3 = 18。若 45ρA = 220，則 A+7 = ? | 已改寫 |

### 5 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 78 | `arithmetic_grade5_foundation_051` | [第16屆IMC台灣區初賽國小五年級 選擇 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 小玉做計算時把「加 65400」看成「減 65400」，結果得到 12340。原來正確答案是多少？ | 已改寫 |
| 79 | `arithmetic_grade5_foundation_052` | [第16屆IMC台灣區初賽國小五年級 選擇 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 王老師上午 7 時從高雄出發，下午 1 時到台北。這段時間時鐘短針一共走了多少度？ | 已改寫 |
| 80 | `arithmetic_grade5_foundation_053` | [第16屆IMC台灣區初賽國小五年級 選擇 4](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | A 噴射機時速 28440 公里，比 B 噴射機時速的 26 倍還多 360 公里。B 噴射機每小時飛多少公里？ | 已改寫 |
| 81 | `arithmetic_grade5_foundation_054` | [第16屆IMC台灣區初賽國小五年級 選擇 5](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | Sam、Sandy、Ariel 分一包糖果。Sam 分到的是 Sandy 的 1/3，Ariel 分到的是 Sandy 的 4 倍。Sam … | 已改寫 |
| 82 | `arithmetic_grade5_foundation_055` | [第16屆IMC台灣區初賽國小五年級 選擇 6](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 雞兔同籠，共有 140 隻腳，其中有 15 隻兔子。請問有幾隻雞？ | 已改寫 |
| 83 | `arithmetic_grade5_foundation_056` | [第16屆IMC台灣區初賽國小五年級 選擇 9](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 媽媽買雞、鴨、鵝各一隻。雞和鴨共 55 又 10 分之 3 元，鴨是 28 又 10 分之 9 元，鵝比雞貴 12 又 10 分之 1 元。… | 已改寫 |
| 84 | `arithmetic_grade5_foundation_057` | [第16屆IMC台灣區初賽國小五年級 選擇 13](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 一本 240 頁的小說要在三天內讀完，第一天讀了全書的 1/3，第二天讀了全書的 0.3。第三天讀了幾頁？ | 已改寫 |
| 85 | `arithmetic_grade5_foundation_058` | [第16屆IMC台灣區初賽國小五年級 選擇 15](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 一個大正方形邊長 12 公分，中間有一個邊長 4 公分的小正方形，剩下部分由 4 個相同長方形組成。每個長方形面積是多少平方公分？ | 已改寫 |
| 86 | `arithmetic_grade5_foundation_059` | [第16屆IMC台灣區初賽國小五年級 選擇 16](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 100 個和尚分 100 個饅頭。大和尚 1 人分 3 個，小和尚 3 人分 1 個。恰好分完時，大和尚和小和尚相差幾人？ | 已改寫 |
| 87 | `arithmetic_grade5_foundation_060` | [第16屆IMC台灣區初賽國小五年級 選擇 18](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 糖果數在 200 和 300 之間，平均分給 39 位同學時都恰好剩下 8 個。下列哪一個數可能是糖果總數？ | 已改寫 |
| 88 | `arithmetic_grade5_foundation_061` | [第16屆IMC台灣區初賽國小五年級 選擇 19](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 一串分數依照這樣的規律排列：分子固定時，分母先從 1 一路增加到和分子一樣大，再倒著減回 1；接著換下一個分子，同樣先增後減。整串是 2/1… | 已改寫 |
| 89 | `arithmetic_grade5_foundation_063` | [第16屆IMC台灣區初賽國小五年級 選擇 22](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 填數 |  | {'type': 'integer', 'value': '37'} | 已知 x÷y÷z=3，x÷y−z=10，x−y=28，求 x+y+z。 | 已改寫 |
| 90 | `arithmetic_grade5_foundation_064` | [第16屆IMC台灣區初賽國小五年級 計算 1-1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 市公車每隔 25 分開出 1 班車，上午 6:10 開出第 1 班。第 5 班是在上午幾點幾分開出？ | 已改寫 |
| 91 | `logic_grade5_foundation_041` | [第16屆IMC台灣區初賽國小五年級 選擇 24](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 王、趙、李三位老師各帶一位學生：小華、小明、小剛。每位老師都比自己帶的學生大 21 歲。已知李老師和小華年齡和為 44，王老師和小華年齡和為… | 已改寫 |
| 92 | `logic_grade5_foundation_042` | [第16屆IMC台灣區初賽國小五年級 選擇 25](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD5%E5%B9%B4%E7%B4%9A%200924-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 26 顆相同玻璃彈珠分裝在 A、B、C、D、E 五個袋子裡，每袋至少 2 顆，且五袋顆數互不相同。秤重時，11 顆以上會超重。已知量測結果為… | 已改寫 |

### 6 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 93 | `arithmetic_grade6_foundation_013` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，選擇第 2 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 把 2025 的四個數字排成最大的四位數與最小的四位數，相減得到新數；再對新數重複同樣操作。這樣連續做很多次後，數值最終會固定成哪一個數？ | 已改寫 |
| 94 | `arithmetic_grade6_foundation_014` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，填充第 1 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 填數 |  | {'type': 'integer', 'value': '67'} | 一次考試有 25 題選擇題，答對一題得 4 分，答錯一題倒扣 1 分，不作答得 0 分。某學生共作答 18 題，其中錯 1 題。她最後得幾分… | 已改寫 |
| 95 | `arithmetic_grade6_foundation_015` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，填充第 2 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 填數 |  | {'type': 'integer', 'value': '85'} | 把 2025 表示成四個互不相同的正整數平方和，而且這四個正整數都必須是 5 的倍數。求這四個正整數的和。 | 已改寫 |
| 96 | `arithmetic_grade6_foundation_016` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，填充第 4 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 填數 |  | {'type': 'integer', 'value': '7592'} | 長方形的長與寬都是整數，且面積是 2025 平方公分。把所有可能的這種長方形都列出後，它們的周長總和是多少？ | 已改寫 |
| 97 | `arithmetic_grade6_foundation_055` | [第16屆IMC台灣區初賽國小六年級 選擇 5](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 一本 250 頁的故事書，Dora 週一到週五每天上午讀 15 頁、下午讀 20 頁；星期六上午讀 10 頁、下午讀 15 頁；星期日休息。… | 已改寫 |
| 98 | `arithmetic_grade6_foundation_056` | [第16屆IMC台灣區初賽國小六年級 選擇 12](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 小白菜價格先上漲 80%，又上漲 60%，之後再下跌 25%，現在每公斤賣 54 元。颱風前每公斤是多少元？ | 已改寫 |
| 99 | `arithmetic_grade6_foundation_057` | [第16屆IMC台灣區初賽國小六年級 選擇 15](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | David、John、Joy 三人把各自的錢拿出來平均分。平均後 David 說他的錢變成原來的 3 倍，John 說他多了 40 元，Jo… | 已改寫 |
| 100 | `arithmetic_grade6_foundation_058` | [第16屆IMC台灣區初賽國小六年級 選擇 16](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 茶葉行有 53/8 公斤成品茶葉，每包裝 600 公克。最後裝不滿一包的茶葉是多少公斤？ | 已改寫 |
| 101 | `arithmetic_grade6_foundation_059` | [第16屆IMC台灣區初賽國小六年級 選擇 17](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 甲、乙兩個一樣大的杯子裝著不同量的果汁。若把乙杯的 1/4 倒入甲杯，且不溢出，這時甲杯果汁高度是乙杯的 2 倍。原來甲杯果汁量是乙杯的幾倍… | 已改寫 |
| 102 | `arithmetic_grade6_foundation_060` | [第16屆IMC台灣區初賽國小六年級 選擇 18](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 彈簧秤原長 8 公分。掛 50 公克時總長 9.5 公分。若掛 80 公克時，總長是多少公分？ | 已改寫 |
| 103 | `arithmetic_grade6_foundation_061` | [第16屆IMC台灣區初賽國小六年級 選擇 20](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 紅燈每 35 分鐘亮一次，藍燈每 40 分鐘亮一次，綠燈每 25 分鐘亮一次。若三燈在晚上 7:00 同時亮，那麼晚上 8:55 之後最先亮… | 已改寫 |
| 104 | `arithmetic_grade6_foundation_062` | [第16屆IMC台灣區初賽國小六年級 選擇 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 小軒從住家到公園，如果每分鐘走 105 公尺，80 分鐘可到達公園。若原路回程時改成每分鐘走 150 公尺，回到住家要幾分鐘？ | 已改寫 |
| 105 | `arithmetic_grade6_foundation_063` | [第16屆IMC台灣區初賽國小六年級 選擇 22](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 已知 x÷y÷z = 3，x÷y − z = 10，x − y = 28，求 x + y + z。 | 已改寫 |
| 106 | `arithmetic_grade6_foundation_064` | [第16屆IMC台灣區初賽國小六年級 計算 1](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 填數 |  | {'type': 'integer', 'value': '145'} | 小雯今天早上發現家裡時鐘沒電，停在上午 6 點 10 分。她換上電池後沒有重新校時就去上班。她的上班時間是上午 9 點；到公司時，離上班還有… | 已改寫 |
| 107 | `geometry_grade6_foundation_013` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，選擇第 7 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'B'} | 在一個圓內畫兩條互相垂直的直徑，並連接四個端點形成一個內接正方形。若這個正方形的面積是 49 平方公分，則圓的面積約是多少平方公分？ | 已改寫 |
| 108 | `geometry_grade6_foundation_014` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，填充第 6 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 填數 | circle_quadrants_point | {'type': 'integer', 'value': '23'} | 如圖，圓內有一點 P，與圓周上的四等分點 A、B、C、D 相連，分圓成四部分，其中三部分的面積為 12、15、20。陰影部分的面積是多少？ | 已改寫 |
| 109 | `logic_grade6_foundation_013` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，選擇第 1 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 在 50 到 130 之間的整數中，去掉所有 2、3、5、7 的倍數後，剩下的數裡最大的是哪一個？ | 已改寫 |
| 110 | `logic_grade6_foundation_014` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，選擇第 4 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 某養雞場有雞，某養殖場有兔。若雞少 8 隻，雞數會是兔數的 3/5；若兔少 8 隻，雞數會是兔數的 2/3。原來雞和兔合起來共有多少隻？ | 已改寫 |
| 111 | `logic_grade6_foundation_015` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，填充第 5 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 甲、乙、丙、丁、戊五人賽跑，名次互不相同。已知乙比甲快，丁比丙快，甲比丙快，而且戊不是第一名也不是最後一名。請問誰有可能是最後一名？ | 已改寫 |
| 112 | `logic_grade6_foundation_045` | [第16屆IMC台灣區初賽國小六年級 選擇 3](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 有一個等腰三角形，但不是正三角形，三邊都是整數，且最大邊長是 4。滿足條件的等腰三角形共有幾種？ | 已改寫 |
| 113 | `logic_grade6_foundation_046` | [第16屆IMC台灣區初賽國小六年級 選擇 2](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 一個正立方體各面寫有正整數，相對兩面的數字和都相等。若 20、49、14 的對面分別是質數 a、b、c，則 a+b+c = ? | 已改寫 |
| 114 | `logic_grade6_foundation_047` | [第16屆IMC台灣區初賽國小六年級 選擇 21](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 至少要有多少人，才能保證其中至少有 3 人生日相同？ | 已改寫 |
| 115 | `logic_grade6_foundation_048` | [第16屆IMC台灣區初賽國小六年級 選擇 24](https://imcct.net/UserFiles/files/2020%E5%88%9D%E8%B3%BD6%E5%B9%B4%E7%B4%9A0926%20-.pdf) | 填數 |  | {'type': 'integer', 'value': '1'} | 取一個正整數，把它的各位數字相加得到一個新的數；如果新的數還不是一位數，就再對它重複同樣的動作，直到只剩一位數為止。從 2026 開始這樣做… | 已改寫 |
| 116 | `mixed_grade6_foundation_009` | [第二十一屆國際數學競賽台灣區複賽，國小六年級，選擇第 8 題](https://imcct.net/UserFiles/files/20250415095625_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 有四張雙面卡片，四張卡片的兩面分別寫著 0/1、2/3、4/5、5/6。每張卡片選一面後排成四位數，首位不能是 0。這樣能組成多少個不同的四… | 已改寫 |

### 7 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 117 | `algebra_grade7_foundation_001` | [IMC Taiwan 2026 複賽 7年級 選擇 1](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '100000'} | 某款電腦連續兩次打九折後，現在售價是 81,000 元。原價是多少元？ | 已改寫 |
| 118 | `algebra_grade7_foundation_002` | [IMC Taiwan 2026 複賽 7年級 填充 3](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '4'} | 定義新運算 x@y = ax - by + 4，其中 a、b 為常數。已知 1@2 = 0，2@(-1) = 11，求 3@2。 | 已改寫 |
| 119 | `algebra_grade7_foundation_003` | [IMC Taiwan 2026 複賽 7年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '6'} | 若 (x² - 3x + 1)(2x² + ax - 4) 展開後不含 x³ 項，求 a。 | 已改寫 |
| 120 | `algebra_grade7_foundation_007` | [IMC Taiwan 2026 複賽 7年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 數線上點 A 與 B 分別表示 3 和 7。點 P 可在數線上任意移動，求 ｜PA - PB｜ 的最大值。 | 已改寫 |
| 121 | `algebra_grade7_foundation_008` | [AMC 8 2020 Problem 15](https://artofproblemsolving.com/wiki/index.php/2020_AMC_8_Problems/Problem_15) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 已知 15% 的 x 等於 20% 的 y。問 y 是 x 的百分之幾？ | 已改寫 |
| 122 | `combinatorics_grade7_foundation_002` | [IMC Taiwan 2026 複賽 7年級 填充 4](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '10'} | 在 2×3 方格中，從左下角走到右上角，每步只能向右或向上。共有多少條不同最短路徑？ | 已改寫 |
| 123 | `combinatorics_grade7_foundation_003` | [IMC Taiwan 2026 複賽 7年級 選擇 7](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '15'} | 6 個人互相握手，每兩人恰好握一次。總共會握多少次手？ | 已改寫 |
| 124 | `combinatorics_grade7_foundation_007` | [IMC Taiwan 2026 複賽 7年級 填充 8](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '1680'} | 把 3 顆黑球、3 顆藍球、3 顆白球排成一直線。若同色球彼此不區分，問共有多少種不同排法？ | 已改寫 |
| 125 | `combinatorics_grade7_foundation_008` | [AMC 8 2011 Problem 8](https://artofproblemsolving.com/wiki/index.php?title=2011_AMC_8_Problems%2FProblem_8) | 填數 |  | {'type': 'integer', 'value': '5'} | 袋子 A 裡有標著 1、3、5 的三張卡片，袋子 B 裡有標著 2、4、6 的三張卡片。從每個袋子各抽一張卡片，兩張卡片上的數字和可能出現多… | 已改寫 |
| 126 | `combinatorics_grade7_foundation_009` | [AMC 8 2020 Problem 10](https://artofproblemsolving.com/wiki/index.php/2020_AMC_8_Problems/Problem_10) | 填數 |  | {'type': 'integer', 'value': '12'} | Zara 有 4 顆不同的彈珠：A、B、S、T。她想把它們排成一直線展示，但不希望 S 和 T 相鄰。問共有多少種排法？ | 已改寫 |
| 127 | `geometry_grade7_foundation_001` | [IMC Taiwan 2026 複賽 7年級 選擇 4](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 一個正 n 邊形中，每個內角與相鄰外角的差是 140°。求 n。 | 已改寫 |
| 128 | `geometry_grade7_foundation_002` | [IMC Taiwan 2026 複賽 7年級 填充 5](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '7'} | 點 P 的座標是 (19 + a, a + 3)。已知 P 在第四象限，且它到 x 軸的距離是 9。求 P 到 y 軸的距離。 | 已改寫 |
| 129 | `geometry_grade7_foundation_003` | [IMC Taiwan 2026 複賽 7年級 計算 1-(1)](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 | geometry_scene | {'type': 'integer', 'value': '6'} | 一塊長方形木板被切成兩部分，其中一部分是直角梯形，另一部分是等腰直角三角形。已知長方形面積是 112，且直角梯形的周長比等腰直角三角形大 1… | 已改寫 |
| 130 | `geometry_grade7_foundation_007` | [AMC 8 2002 Problem 20](https://artofproblemsolving.com/wiki/index.php?title=2002_AMC_8_Problems%2FProblem_20) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 三角形 XYZ 的面積是 8。A、B 分別是邊 XY、XZ 的中點，從頂點 X 向底邊 YZ 作高 XC，且 C 是 YZ 的中點。圖中陰影… | 已改寫 |
| 131 | `geometry_grade7_foundation_008` | [AMC 8 2000 Problem 25](https://artofproblemsolving.com/wiki/index.php/2000_AMC_8_Problems/Problem_25) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'B'} | 長方形 ABCD 的面積是 72。把頂點 A、邊 BC 的中點以及邊 CD 的中點連起來形成一個三角形。求這個三角形的面積。 | 已改寫 |
| 132 | `geometry_grade7_foundation_009` | [AMC 8 2018 Problem 22](https://artofproblemsolving.com/wiki/index.php/2018_AMC_8_Problems/Problem_22) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'B'} | 正方形 ABCD 中，E 是邊 CD 的中點，BE 與對角線 AC 交於 F。已知四邊形 AFED 的面積是 45。求正方形 ABCD 的面… | 已改寫 |
| 133 | `geometry_grade7_foundation_010` | [AMC 8 2000 Problem 19](https://artofproblemsolving.com/wiki/index.php/2000_AMC_8_Problems/Problem_19) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'C'} | 三段半徑都是 5 的圓弧圍成一個封閉區域。其中弧 AB 與弧 AD 都是四分之一圓，弧 BCD 是半圓。求這個區域的面積。 | 已改寫 |
| 134 | `logic_grade7_foundation_001` | [IMC Taiwan 2026 複賽 7年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 甲、乙、丙三人中，只有一人說真話。甲說：「乙在說謊。」乙說：「丙在說真話。」丙說：「甲和乙都在說謊。」說真話的是誰？ | 已改寫 |
| 135 | `logic_grade7_foundation_002` | [IMC Taiwan 2026 複賽 7年級 填充 2](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 三個盒子上分別貼著「紅球」、「藍球」、「紅藍各一球」，但三張標籤全都貼錯。只抽一次一顆球，最少從哪個盒子抽，才能確定三個盒子的內容？ | 已改寫 |
| 136 | `logic_grade7_foundation_003` | [IMC Taiwan 2026 複賽 7年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '17'} | 某串數列依規則排成 2, 3, 5, 8, 12, ...。每一項都等於前一項加上一個逐次增加的整數。下一項是多少？ | 已改寫 |
| 137 | `logic_grade7_foundation_007` | [AMC 8 2023 Problem 8](https://artofproblemsolving.com/wiki/index.php?title=2023_AMC_8_Problems%2FProblem_8) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 四位選手 Lola、Lolo、Tiya、Tiyo 參加桌球循環賽。每兩位選手彼此交手 2 次，全部比賽分成 6 輪進行，每一輪四人剛好分成兩… | 已改寫 |
| 138 | `logic_grade7_foundation_008` | [AJHSME 1985 Problem 25](https://artofproblemsolving.com/wiki/index.php?title=1985_AJHSME_Problems%2FProblem_25) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 桌上有 5 張卡片可見的一面分別是 P、Q、3、4、6。每張卡片另一面不是字母就是整數。有人聲稱：「如果某張卡片有一面是母音字母，那另一面一… | 已改寫 |
| 139 | `logic_grade7_foundation_009` | [AMC 8 2004 Problem 13](https://artofproblemsolving.com/wiki/index.php?title=2004_AMC_8_Problems%2FProblem_13) | 選擇 |  | {'type': 'choice', 'value': 'E'} | Amy、Bill、Celine 三人的年齡彼此不同。現在知道下列三句話中恰好只有一句是真的： I. Bill 最年長。 II. Amy 不是… | 已改寫 |
| 140 | `number_theory_grade7_foundation_001` | [IMC Taiwan 2026 複賽 7年級 填充 6](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '2'} | 以下都用七進位表示。若 11₇ × 11₇ = 1a1₇，求數字 a。 | 已改寫 |
| 141 | `number_theory_grade7_foundation_002` | [IMC Taiwan 2026 複賽 7年級 填充 7](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '243'} | 從 1 到 1000 的整數中，十進位表示恰好出現一次數字 7 的共有多少個？ | 已改寫 |
| 142 | `number_theory_grade7_foundation_007` | [IMC Taiwan 2026 複賽 7年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 填數 |  | {'type': 'integer', 'value': '16'} | 從數字 4、5、6、7、8 中任選三個不同的數字排成三位數。這些三位數中，同時是 2 的倍數與 3 的倍數的共有多少個？ | 已改寫 |
| 143 | `number_theory_grade7_foundation_008` | [AMC 8 2010 Problem 24](https://artofproblemsolving.com/wiki/index.php/2010_AMC_8_Problems/Problem_24) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 比較 10⁸、5¹²、2²⁴ 這三個數。若把它們由小到大排列，排在中間的是哪一個？ | 已改寫 |
| 144 | `number_theory_grade7_foundation_009` | [AMC 8 2004 Problem 19](https://artofproblemsolving.com/wiki/index.php?title=2004_AMC_8_Problems%2FProblem_19) | 填數 |  | {'type': 'integer', 'value': '62'} | 有一個整數大於 2，且它除以 3、4、5、6 時都餘 2。這樣的整數中最小的是多少？ | 已改寫 |
| 145 | `number_theory_grade7_foundation_010` | [IMC Taiwan 2026 複賽 7年級 選擇 8](https://imcct.net/UserFiles/news/583/20260413110023_0.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 在 1 到 2026 的所有自然數中，找出所有是 2 或 3 的倍數、但不是 5 的倍數的數。這樣的數共有多少個？ | 已改寫 |

### 8 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 146 | `algebra_grade8_foundation_001` | [IMC Taiwan 2026 複賽 8年級 選擇 4](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '-9'} | 若 5 是方程式 ax² + 4ax - 45 = 0 的一個根，求另一個根。 | 已改寫 |
| 147 | `algebra_grade8_foundation_002` | [IMC Taiwan 2026 複賽 8年級 選擇 7](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '-8'} | 兩直線 3x - 2y = 5 與 ax + y = 7 的交點是 (1, b)。求 a×b。 | 已改寫 |
| 148 | `algebra_grade8_foundation_007` | [IMC Taiwan 2026 複賽 8年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 非零實數 a、b 滿足 5(a² + b²) = (2a + b)²，求 a/b。 | 已改寫 |
| 149 | `algebra_grade8_foundation_008` | [AMC 8 2019 Problem 20](https://artofproblemsolving.com/wiki/index.php?title=2019_AMC_8_Problems%2FProblem_20) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 有多少個不同的實數 x 滿足 (x² - 5)² = 16？ | 已改寫 |
| 150 | `algebra_grade8_foundation_009` | [IMC Taiwan 2026 複賽 8年級 選擇 8](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 一個 11 項等比數列依序為 a, ar, ar², ...。已知第 5 項是第 8 項的 8 倍，而且最後 5 項的和是 31。求全部 1… | 已改寫 |
| 151 | `combinatorics_grade8_foundation_001` | [IMC Taiwan 2026 複賽 8年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '24'} | 用數字 1、2、3、4 可組成多少個沒有重複數字的三位數？ | 已改寫 |
| 152 | `combinatorics_grade8_foundation_002` | [IMC Taiwan 2026 複賽 8年級 填充 5](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '15'} | 從 7 個人中選出 3 人組成小組，若甲一定要被選上，則共有多少種選法？ | 已改寫 |
| 153 | `combinatorics_grade8_foundation_003` | [IMC Taiwan 2026 複賽 8年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '31'} | 一個 5 元集合有多少個非空子集合？ | 已改寫 |
| 154 | `combinatorics_grade8_foundation_007` | [IMC Taiwan 2026 複賽 8年級 填充 7](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '121'} | 只使用 10 元硬幣、50 元硬幣和 100 元紙鈔，剛好湊成 1000 元。每種面額都可以不用，且不考慮取用順序。共有多少種不同組合？ | 已改寫 |
| 155 | `combinatorics_grade8_foundation_008` | [AMC 8 2026 Problem 20](https://artofproblemsolving.com/wiki/index.php?title=2026_AMC_8_Problems%2FProblem_20) | 填數 |  | {'type': 'integer', 'value': '13'} | 某地使用兩種硬幣：金幣厚 1 毫米，銀幣厚 3 毫米。若一疊硬幣總高度要剛好是 8 毫米，而且同樣種類的硬幣彼此不區分，但上下順序不同算不同… | 已改寫 |
| 156 | `combinatorics_grade8_foundation_009` | [AMC 8 2011 Problem 12](https://artofproblemsolving.com/wiki/index.php/2011_AMC_8_Problems/Problem_12) | 選擇 |  | {'type': 'choice', 'value': 'B'} | Angie、Bridget、Carlos、Diego 隨機坐在正方形桌子的四邊，每人一邊。求 Angie 和 Carlos 剛好坐在相對位置… | 已改寫 |
| 157 | `geometry_grade8_foundation_001` | [IMC Taiwan 2026 複賽 8年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 梯形的中線長是 4，高是 8。求它的面積。 | 已改寫 |
| 158 | `geometry_grade8_foundation_002` | [IMC Taiwan 2026 複賽 8年級 填充 4](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 長方形 ABCD 中，AB = 2，BC = 1，點 E 在 BC 上。把長方形沿 AE 對折後，點 B 恰好落在邊 CD 上。求 ∠EAB… | 已改寫 |
| 159 | `geometry_grade8_foundation_003` | [IMC Taiwan 2026 複賽 8年級 填充 8](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 | geometry_scene | {'type': 'integer', 'value': '2'} | 一個三角形三邊長分別為 6、8、10。求它的內切圓半徑。 | 已改寫 |
| 160 | `geometry_grade8_foundation_007` | [AMC 8 2003 Problem 21](https://artofproblemsolving.com/wiki/index.php?title=2003_AMC_8_Problems%2FProblem_21) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 梯形 ABCD 的面積是 164 平方公分，高是 8 公分，兩條腰的長分別是 10 公分與 17 公分，且較長的底邊上的兩個底角都是銳角。求… | 已改寫 |
| 161 | `geometry_grade8_foundation_009` | [IMC Taiwan 2026 複賽 8年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 直角三角形 ABC 中，∠ACB = 90°。在邊 AB、BC 外側分別作正方形 ABDE 與 BCFG，已知這兩個正方形的面積分別是 22… | 已改寫 |
| 162 | `geometry_grade8_foundation_010` | [AMC 8 2011 Problem 25](https://artofproblemsolving.com/wiki/index.php/2011_AMC_8_Problems/Problem_25) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 一個半徑為 1 的圓內切於一個正方形，並且同時外接於另一個旋轉了 45° 的正方形。求「圓內但不在小正方形內」的面積，與「大正方形內但不在小… | 已改寫 |
| 163 | `logic_grade8_foundation_001` | [IMC Taiwan 2026 複賽 8年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '4'} | 某月的 1 日是星期三，且這個月有 31 天。這個月一共有幾個星期一？ | 已改寫 |
| 164 | `logic_grade8_foundation_002` | [IMC Taiwan 2026 複賽 8年級 填充 1](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 甲、乙、丙三人分別喜歡不同的顏色：紅、藍、綠。已知甲不喜歡紅色，乙不喜歡藍色，丙喜歡綠色。問乙喜歡什麼顏色？ | 已改寫 |
| 165 | `logic_grade8_foundation_003` | [IMC Taiwan 2026 複賽 8年級 選擇 9](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '21'} | 用火柴棒排圖形：第 1 個圖形要 3 根，第 2 個要 5 根，第 3 個要 7 根，照此規律，第 10 個圖形要幾根？ | 已改寫 |
| 166 | `logic_grade8_foundation_007` | [AMC 8 2023 Problem 18](https://artofproblemsolving.com/wiki/index.php/2023_AMC_8_Problems/Problem_18) | 填數 |  | {'type': 'integer', 'value': '411'} | 一隻蚱蜢從起點出發，向右跳 5 格或向左跳 3 格都可以。要到達起點右方 2023 格的位置，最少要跳幾次？ | 已改寫 |
| 167 | `logic_grade8_foundation_008` | [AJHSME 1987 Problem 17](https://artofproblemsolving.com/wiki/index.php?title=1987_AJHSME_Problems) | 選擇 |  | {'type': 'choice', 'value': 'D'} | Abby、Bret、Carl、Dana 坐在編號 1 到 4 的四個座位上。Joe 說了兩句話：「Bret 坐在 Carl 旁邊。」「Abb… | 已改寫 |
| 168 | `logic_grade8_foundation_009` | [AMC 8 2017 Problem 8](https://artofproblemsolving.com/wiki/index.php?title=2017_AMC_8_Problems%2FProblem_8) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 某個兩位數的門牌號碼同時滿足：下面四句話中恰好有三句是真的。 (1) 它是質數。 (2) 它是偶數。 (3) 它可以被 7 整除。 (4) … | 已改寫 |
| 169 | `number_theory_grade8_foundation_003` | [IMC Taiwan 2026 複賽 8年級 選擇 3](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '1995000'} | 計算 998² + 999×1000 - 4。 | 已改寫 |
| 170 | `number_theory_grade8_foundation_007` | [IMC Taiwan 2026 複賽 8年級 計算 2(2)](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 填數 |  | {'type': 'integer', 'value': '707'} | 從 1 到 100 中選出兩個不同的整數，不考慮先後順序。這兩個數的和是 7 的倍數的共有多少組？ | 已改寫 |
| 171 | `number_theory_grade8_foundation_008` | [AMC 8 2014 Problem 22](https://artofproblemsolving.com/wiki/index.php/2014_AMC_8_Problems/Problem_22) | 填數 |  | {'type': 'integer', 'value': '9'} | 某個兩位數滿足：它的數字乘積加上數字和，剛好等於這個兩位數本身。求這個兩位數的個位數。 | 已改寫 |
| 172 | `number_theory_grade8_foundation_009` | [AMC 8 2016 Problem 24](https://artofproblemsolving.com/wiki/index.php?title=2016_AMC_8_Problems%2FProblem_24) | 填數 |  | {'type': 'integer', 'value': '24'} | 把數字 1、2、3、4、5 各用一次排成五位數。這些五位數中，有多少個能被 4 整除？ | 已改寫 |
| 173 | `number_theory_grade8_foundation_010` | [IMC Taiwan 2026 複賽 8年級 選擇 1](https://imcct.net/UserFiles/news/583/20260413110023_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 若二次式 x²+ax+48 可以分解成兩個一次整係數多項式的乘積，則 a 共有多少種可能值？ | 已改寫 |

### 9 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 174 | `algebra_grade9_foundation_001` | [IMC Taiwan 2026 複賽 9年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 拋物線 y = 3x² - 2x - 5 與 x 軸交於兩點。求這兩個交點之間的距離。 | 待改寫 |
| 175 | `algebra_grade9_foundation_003` | [IMC Taiwan 2026 複賽 9年級 填充 4](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 若 x² + 4y² + 2x - 4y + 2 = 0，求 x + y。 | 待改寫 |
| 176 | `algebra_grade9_foundation_008` | [AMC 10A 2023 Problem 2](https://artofproblemsolving.com/wiki/index.php?title=2023_AMC_10A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 1/3 個大披薩加上 3.5 杯柳橙片，與 3/4 個大披薩加上 0.5 杯柳橙片重量相同。每 1 杯柳橙片重 1/4 磅。問 1 個大披薩… | 待改寫 |
| 177 | `combinatorics_grade9_foundation_001` | [IMC Taiwan 2026 複賽 9年級 選擇 4](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '120'} | 6 個人圍成一圈坐下。若旋轉後視為相同，則共有多少種不同坐法？ | 待改寫 |
| 178 | `combinatorics_grade9_foundation_002` | [IMC Taiwan 2026 複賽 9年級 填充 3](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '15'} | 長度為 6 的 0-1 字串中，恰有 2 個 1 的共有多少個？ | 待改寫 |
| 179 | `combinatorics_grade9_foundation_003` | [IMC Taiwan 2026 複賽 9年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '21'} | 把 8 顆相同糖果分給 3 個小朋友，每人至少 1 顆。共有多少種分法？ | 待改寫 |
| 180 | `combinatorics_grade9_foundation_007` | [IMC Taiwan 2026 複賽 9年級 填充 5](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '12'} | 三角形的周長是 24，且三邊長都是正整數。若全等三角形視為同一種，問共有多少種不同三角形？ | 待改寫 |
| 181 | `combinatorics_grade9_foundation_008` | [AMC 10A 2018 Problem 4](https://artofproblemsolving.com/wiki/index.php/2018_AMC_10A_Problems/Problem_4) | 填數 |  | {'type': 'integer', 'value': '24'} | 一位學生要在 6 節課中安排 3 門不同的數學課：代數、幾何、數論。要求任兩門數學課都不能排在相鄰節次。問共有多少種安排方式？ | 待改寫 |
| 182 | `combinatorics_grade9_foundation_009` | [AMC 10A 2016 Problem 14](https://artofproblemsolving.com/wiki/index.php/2016_AMC_10A_Problems/Problem_14) | 填數 |  | {'type': 'integer', 'value': '337'} | 把 2016 寫成若干個 2 和若干個 3 的和，且不考慮順序（2 的個數或 3 的個數可以是 0）。共有多少種不同寫法？ | 待改寫 |
| 183 | `geometry_grade9_foundation_001` | [IMC Taiwan 2026 複賽 9年級 填充 1](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 | geometry_scene | {'type': 'integer', 'value': '5'} | 如圖，長方形 ABCD 中，沿 BF 將三角形 BCF 對摺，使點 C 恰好落到 AD 上的點 E。若 AB = 9，AE = 12，求 C… | 待改寫 |
| 184 | `geometry_grade9_foundation_002` | [IMC Taiwan 2026 複賽 9年級 填充 4](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'B'} | 圓 O 與一個以 O 為直角頂點的等腰直角三角形的斜邊相交於兩個四等分點。若圓半徑是 1，求這個等腰直角三角形的斜邊長。 | 待改寫 |
| 185 | `geometry_grade9_foundation_003` | [IMC Taiwan 2026 複賽 9年級 選擇 8](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 | coordinate_plane | {'type': 'choice', 'value': 'A'} | 原點關於直線 y = 2x + 1 的對稱點坐標是什麼？ | 待改寫 |
| 186 | `geometry_grade9_foundation_007` | [IMC Taiwan 2026 複賽 9年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 點 P 在圓外。已知從 P 到圓上點的最遠距離是 11 公分，最近距離是 5 公分。求這個圓的半徑。 | 待改寫 |
| 187 | `geometry_grade9_foundation_008` | [AMC 10B 2021 Problem 10](https://artofproblemsolving.com/wiki/index.php/2021_AMC_10B_Problems) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 一個倒圓錐形容器，底面半徑是 12 公分，高是 18 公分，裡面裝滿了水。把這些水全部倒進一個底面半徑 24 公分的直圓柱中。問圓柱中的水高… | 待改寫 |
| 188 | `geometry_grade9_foundation_009` | [IMC Taiwan 2026 複賽 9年級 選擇 7](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 | coordinate_plane | {'type': 'choice', 'value': 'C'} | 一個高腳杯的截面可視為一條拋物線，頂點是 N。當水面與拋物線交於 A、B 兩點時，若 AB = 10 公分，且水面到頂點的垂直距離 MN =… | 待改寫 |
| 189 | `geometry_grade9_foundation_010` | [AMC 8 2019 Problem 21](https://artofproblemsolving.com/wiki/index.php/2019_AMC_8_Problems/Problem_21) | 選擇 |  | {'type': 'choice', 'value': 'E'} | 三條直線 y = 5、y = x + 1、y = 1 - x 圍成一個三角形。求這個三角形的面積。 | 待改寫 |
| 190 | `logic_grade9_foundation_001` | [IMC Taiwan 2026 複賽 9年級 選擇 3](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '4157'} | 若某種密碼規則把 CAT 編成 3120，因為 C 是第 3 個字母、A 是第 1 個字母、T 是第 20 個字母。依同樣規則，DOG 會編… | 待改寫 |
| 191 | `logic_grade9_foundation_002` | [IMC Taiwan 2026 複賽 9年級 填充 6](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '10'} | 有 100 盞燈一開始都關著。第 1 輪把所有燈切換，第 2 輪切換編號是 2 的倍數的燈，第 3 輪切換編號是 3 的倍數的燈，如此做到第… | 待改寫 |
| 192 | `logic_grade9_foundation_003` | [IMC Taiwan 2026 複賽 9年級 選擇 7](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 四條路中只有一條通往學校。甲說第 1 條不通，乙說第 2 條通，丙說第 1 條、第 2 條和第 3 條都不通。已知三人中只有一人說真話，哪一… | 待改寫 |
| 193 | `logic_grade9_foundation_007` | [AMC 10A 2019 Problem 23](https://artofproblemsolving.com/wiki/index.php/2019_AMC_10A_Problems/Problem_23) | 填數 |  | {'type': 'integer', 'value': '5979'} | Tadd、Todd、Tucker 三人輪流報數。Tadd 先說 1 個數，接著 Todd 說接下來 2 個數，再來 Tucker 說接下來 … | 待改寫 |
| 194 | `logic_grade9_foundation_008` | [AMC 10A 2018 Problem 5](https://artofproblemsolving.com/wiki/index.php/2018_AMC_10A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'D'} | Alice 說：「離最近城鎮至少有 6 英里。」Bob 說：「離最近城鎮至多有 5 英里。」Charlie 說：「其實離最近城鎮至多有 4 … | 待改寫 |
| 195 | `logic_grade9_foundation_009` | [AMC 10A 2025 Problem 8](https://artofproblemsolving.com/wiki/index.php?title=2025_AMC_12A_Problems%2FProblem_4) | 選擇 |  | {'type': 'choice', 'value': 'B'} | Agnes 在紙上寫了四句話： 1. 這四句話中至少有一句是真的。 2. 這四句話中至少有兩句是真的。 3. 這四句話中至少有兩句是假的。 … | 待改寫 |
| 196 | `number_theory_grade9_foundation_002` | [IMC Taiwan 2026 複賽 9年級 填充 2](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 計算 (1 - 1/2²)(1 - 1/3²)⋯(1 - 1/2026²)。 | 待改寫 |
| 197 | `number_theory_grade9_foundation_003` | [IMC Taiwan 2026 複賽 9年級 選擇 1](https://imcct.net/UserFiles/news/583/20260413110023_2.pdf) | 填數 |  | {'type': 'integer', 'value': '91170'} | 將 123456789 連續寫 2026 次形成一個很長的數，問這個數的數字和是多少？ | 待改寫 |
| 198 | `number_theory_grade9_foundation_007` | [AMC 10A 2023 Problem 12](https://artofproblemsolving.com/wiki/index.php/2023_AMC_10A_Problems) | 填數 |  | {'type': 'integer', 'value': '14'} | 有多少個三位正整數 N 同時滿足：N 可被 7 整除，而且把 N 的數字倒過來後得到的數可被 5 整除？ | 待改寫 |
| 199 | `number_theory_grade9_foundation_008` | [AMC 10B 2019 Problem 12](https://artofproblemsolving.com/wiki/index.php/2019_AMC_10B_Problems/Problem_12) | 填數 |  | {'type': 'integer', 'value': '22'} | 小於 2019 的正整數中，把它寫成七進位後，各位數字和的最大值是多少？ | 待改寫 |
| 200 | `number_theory_grade9_foundation_009` | [AMC 8 2026 Problem 16](https://artofproblemsolving.com/wiki/index.php?title=2026_AMC_8_Problems%2FProblem_16) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 所有四位正整數中，若每一位數字都必須是偶數，則這些數裡有多少比例能被 4 整除？ | 待改寫 |

### 10 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 201 | `algebra_grade10_foundation_001` | [IMC Taiwan 2026 複賽 10年級 選擇 4](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '2'} | 若 (7.2)ˣ = (0.8)ʸ = 3，求 1/x - 1/y。 | 待改寫 |
| 202 | `algebra_grade10_foundation_002` | [IMC Taiwan 2026 複賽 10年級 選擇 5](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 設 f(x) = x² - 4x + 7，且定義域為 -1 ≤ x ≤ a。若此區間上的最大值是 12，最小值是 3，則 a 落在哪個區間？ | 待改寫 |
| 203 | `algebra_grade10_foundation_003` | [IMC Taiwan 2026 複賽 10年級 選擇 7](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '60'} | 一個等比數列的前四項和是 600，且第一項與第二項的乘積是 675。若公比是整數，求第一項與第二項的和。 | 待改寫 |
| 204 | `algebra_grade10_foundation_007` | [IMC Taiwan 2026 複賽 10年級 選擇 6](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '8'} | 若方程 (x - a)(x - 8) - 1 = 0 有兩個整數解，求 a。 | 待改寫 |
| 205 | `algebra_grade10_foundation_008` | [AMC 10A 2021 Problem 8](https://artofproblemsolving.com/wiki/index.php/2021_AMC_10A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'E'} | 某學生要計算 66×1.ababab...，其中 ab 是兩位數循環小數的循環節。但他誤把它當成 66×1.ab 來算，結果發現自己的答案比… | 待改寫 |
| 206 | `combinatorics_grade10_foundation_001` | [IMC Taiwan 2026 複賽 10年級 選擇 3](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '210'} | 從 8 個人中選出 2 對不重疊的人做雙打隊伍。若兩隊不分先後，共有多少種選法？ | 待改寫 |
| 207 | `combinatorics_grade10_foundation_002` | [IMC Taiwan 2026 複賽 10年級 填充 3](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '84'} | 把 10 個相同球放入 4 個不同盒子，每盒至少 1 球。共有多少種放法？ | 待改寫 |
| 208 | `combinatorics_grade10_foundation_003` | [IMC Taiwan 2026 複賽 10年級 選擇 8](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '30'} | 從點 (0,0,0) 走到 (2,2,1)，每步只能讓其中一個座標加 1。共有多少條最短路徑？ | 待改寫 |
| 209 | `combinatorics_grade10_foundation_007` | [AMC 12A 2022 Problem 7](https://artofproblemsolving.com/wiki/index.php/2022_AMC_12A_Problems) | 填數 |  | {'type': 'integer', 'value': '540'} | 一個長方形被切成 5 個區域：上排由左至右有 2 個區域，記為 A、B；下排由左至右有 3 個區域，記為 C、D、E。共邊（相鄰）的區域配對… | 待改寫 |
| 210 | `combinatorics_grade10_foundation_008` | [AMC 10A 2013 Problem 24](https://artofproblemsolving.com/wiki/index.php/2013_AMC_10A_Problems/Problem_24) | 填數 |  | {'type': 'integer', 'value': '900'} | 兩所學校各有 3 位選手，分別記作 A、B、C 與 X、Y、Z。規定每位左邊學校的選手都要和右邊學校的每位選手對戰 2 次。比賽共分成 6 … | 待改寫 |
| 211 | `combinatorics_grade10_foundation_009` | [AMC 10A Fall 2021 Problem 21](https://artofproblemsolving.com/wiki/index.php/2021_Fall_AMC_12A_Problems/Problem_18) | 填數 |  | {'type': 'integer', 'value': '16'} | 20 顆球各自獨立且等機率地投入 5 個箱子之一。令 p 為「某一箱恰有 3 顆、另一箱恰有 5 顆，其餘三箱各有 4 顆」的機率；令 q … | 待改寫 |
| 212 | `geometry_grade10_foundation_001` | [IMC Taiwan 2026 複賽 10年級 填充 4](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 圓 C: x² + y² - 2x - 24 = 0 與直線 L: 3x + 4y + k = 0 相交於兩個不同點。求 k 的範圍。 | 待改寫 |
| 213 | `geometry_grade10_foundation_002` | [IMC Taiwan 2026 複賽 10年級 填充 6](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 選擇 | coordinate_plane | {'type': 'choice', 'value': 'A'} | 點 A(3, 5) 在直線 L 上的投影點是 A0(7, -1)。求直線 L 的方程式，寫成 ax + by = c。 | 待改寫 |
| 214 | `geometry_grade10_foundation_003` | [IMC Taiwan 2026 複賽 10年級 填充 8](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 選擇 | coordinate_plane | {'type': 'choice', 'value': 'A'} | 圓上有三點 A(3, 0)、B(9, 0)、C(x, y)，圓半徑為 5。若要使三角形 ABC 的面積最大，求點 C 的坐標。 | 待改寫 |
| 215 | `geometry_grade10_foundation_007` | [AMC 10A 2022 Problem 10](https://artofproblemsolving.com/wiki/index.php/2022_AMC_10A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'E'} | 一張長方形卡片的對角線長 8 公分。從兩個對角各切去一個邊長 1 公分的小正方形後，這兩個缺角最靠近的兩個頂點之間距離是 4√2 公分。求原… | 待改寫 |
| 216 | `geometry_grade10_foundation_008` | [AMC 10A 2023 Problem 4](https://artofproblemsolving.com/wiki/index.php?title=2023_AMC_10A_Problems%2FProblem_4) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 一個四邊形的四個邊長都是整數，周長是 26，且其中一邊長是 4。問這個四邊形某一邊可能的最大長度是多少？ | 待改寫 |
| 217 | `geometry_grade10_foundation_009` | [AMC 10B 2004 Problem 22](https://artofproblemsolving.com/wiki/index.php/2004_AMC_10B_Problems/Problem_22) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 一個三角形的三邊長是 5、12、13。求它的內心與外心之間的距離。 | 待改寫 |
| 218 | `geometry_grade10_foundation_010` | [AMC 10A 2004 Problem 20](https://artofproblemsolving.com/wiki/index.php/2004_AMC_10A_Problems/Problem_20) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 在正方形 ABCD 中，點 E 在 AD 上，點 F 在 CD 上，且三角形 BEF 是正三角形。求三角形 DEF 的面積與三角形 ABE … | 待改寫 |
| 219 | `logic_grade10_foundation_001` | [IMC Taiwan 2026 複賽 10年級 選擇 1](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '2'} | 有 9 顆外觀相同的球，其中 1 顆較重。用沒有砝碼的天平最少要稱幾次，才能保證找出較重的球？ | 待改寫 |
| 220 | `logic_grade10_foundation_002` | [IMC Taiwan 2026 複賽 10年級 填充 1](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '13'} | 找最小的大於 1 的正整數 n，使得 n 除以 2、3、4 都餘 1。n 是多少？ | 待改寫 |
| 221 | `logic_grade10_foundation_003` | [IMC Taiwan 2026 複賽 10年級 選擇 9](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '6'} | 有 4 張卡片，分別寫著 1、2、3、4。從中選出兩張排成兩位數，且十位數比個位數大。共有多少個不同兩位數？ | 待改寫 |
| 222 | `logic_grade10_foundation_007` | [AMC 10A 2022 Problem 12](https://artofproblemsolving.com/wiki/index.php/2022_AMC_10A_Problems/Problem_12) | 填數 |  | {'type': 'integer', 'value': '7'} | 31 個孩子依照回答習慣分成三種：永遠說真話的人、永遠說假話的人、以及真話與假話交替的人（交替的人可能從真話開始，也可能從假話開始）。校長依… | 待改寫 |
| 223 | `logic_grade10_foundation_009` | [AMC 10A 2010 Problem 15](https://artofproblemsolving.com/wiki/index.php/2010_AMC_12A_Problems/Problem_12) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 在一個沼澤裡有兩種會說話的生物：蟾蜍永遠說真話，青蛙永遠說假話。Brian、Chris、LeRoy、Mike 四位居民分別說： Brian：… | 待改寫 |
| 224 | `number_theory_grade10_foundation_002` | [IMC Taiwan 2026 複賽 10年級 計算 2](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '58'} | 求方程 5x + 7y = 2026 的非負整數解共有多少組。 | 待改寫 |
| 225 | `number_theory_grade10_foundation_003` | [IMC Taiwan 2026 複賽 10年級 選擇 6](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '11'} | 四位數 2a5b 可被 36 整除。求 a + b 的最大值。 | 待改寫 |
| 226 | `number_theory_grade10_foundation_007` | [IMC Taiwan 2026 複賽 10年級 選擇 1](https://imcct.net/UserFiles/news/583/20260417120202_1.pdf) | 填數 |  | {'type': 'integer', 'value': '25'} | 令 S = 1! + 2! + 3! + ⋯ + 100!。求 S² 除以 28 的餘數。 | 待改寫 |
| 227 | `number_theory_grade10_foundation_008` | [AMC 10A 2018 Problem 22](https://artofproblemsolving.com/wiki/index.php/2018_AMC_10A_Problems/Problem_22) | 填數 |  | {'type': 'integer', 'value': '13'} | 正整數 a、b、c、d 滿足 gcd(a,b)=24、gcd(b,c)=36、gcd(c,d)=54，而且 70 < gcd(d,a) < … | 待改寫 |
| 228 | `number_theory_grade10_foundation_009` | [AMC 10A 2015 Problem 18](https://artofproblemsolving.com/wiki/index.php/2015_AMC_10A_Problems/Problem_18) | 填數 |  | {'type': 'integer', 'value': '21'} | 十六進位除了 0 到 9 外，還用 A 到 F 表示 10 到 15。在前 1000 個正整數中，設有 n 個數的十六進位表示只含數字 0 … | 待改寫 |
| 229 | `number_theory_grade10_foundation_010` | [AMC 10A 2014 Problem 20](https://artofproblemsolving.com/wiki/index.php/2014_AMC_10A_Problems/Problem_20) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 把一個有 k 位數的整數 88…8（每一位都是 8）乘以 8，所得乘積的各位數字和是 1000。求 k。 | 待改寫 |

### 11 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 230 | `algebra_grade11_foundation_001` | [IMC Taiwan 2026 複賽 11年級 選擇 1](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 設 a = log_2 3，b = log_3 4，c = log_4 5，d = log_5 6。由大到小排列這四個數。 | 待改寫 |
| 231 | `algebra_grade11_foundation_007` | [IMC Taiwan 2026 複賽 11年級 選擇 3](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'A'} | 設 log 表示常用對數。方程 x⁽ˡᵒᵍˣ⁾ = 10⁶ x 的所有正實數解是哪一組？ | 待改寫 |
| 232 | `algebra_grade11_foundation_008` | [AMC 12A 2024 Problem 5](https://artofproblemsolving.com/wiki/index.php/2024_AMC_12A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 一組資料共有 20 個數，平均數是 45，其中有些數是 6。把所有等於 6 的數都移除後，剩下資料的平均數變成 66。問原本資料中有幾個 6… | 待改寫 |
| 233 | `combinatorics_grade11_foundation_001` | [IMC Taiwan 2026 複賽 11年級 選擇 7](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '30'} | 字母 AABBC 可排成多少個不同的五字母串？ | 待改寫 |
| 234 | `combinatorics_grade11_foundation_002` | [IMC Taiwan 2026 複賽 11年級 填充 3](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '9'} | 4 封不同信件要放入 4 個已寫好姓名的信封，且沒有任何一封信放進對應的信封。共有多少種放法？ | 待改寫 |
| 235 | `combinatorics_grade11_foundation_007` | [AMC 12A 2022 Problem 10](https://artofproblemsolving.com/wiki/index.php/2022_AMC_10A_Problems/Problem_14) | 填數 |  | {'type': 'integer', 'value': '144'} | 把整數 1 到 14 分成 7 組，每組恰有 2 個數，並且每組中較大的數至少是較小的數的 2 倍。問共有多少種分組方式？ | 待改寫 |
| 236 | `combinatorics_grade11_foundation_008` | [AMC 12A 2022 Problem 24](https://artofproblemsolving.com/wiki/index.php/2022_AMC_10A_Problems/Problem_24) | 填數 |  | {'type': 'integer', 'value': '1296'} | 用數字 0、1、2、3、4 組成長度為 5 的字串。若對每個 j=1,2,3,4，都至少有 j 個位置上的數字小於 j，問這樣的字串共有多少… | 待改寫 |
| 237 | `combinatorics_grade11_foundation_009` | [AMC 12A 2007 Problem 16](https://artofproblemsolving.com/wiki/index.php/2007_AMC_12A_Problems/Problem_16) | 填數 |  | {'type': 'integer', 'value': '112'} | 有多少個三位數由三個互不相同的數字組成，且其中一個數字恰好是另外兩個數字的平均數？ | 待改寫 |
| 238 | `geometry_grade11_foundation_001` | [IMC Taiwan 2026 複賽 11年級 選擇 4](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 在 0 ≤ x ≤ π 中，令 y = √3 sin x + cos x。若最大值為 m、最小值為 n，求 m + n。 | 待改寫 |
| 239 | `geometry_grade11_foundation_002` | [IMC Taiwan 2026 複賽 11年級 選擇 5](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 求平面 x - 2y + 2z - 1 = 0 與平面 2x - 4y + 4z + 5 = 0 之間的距離。 | 待改寫 |
| 240 | `geometry_grade11_foundation_003` | [IMC Taiwan 2026 複賽 11年級 計算 1-(3)](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 一個正四角錐的底面是正方形，體積是 96，底面正方形對角線長是 4√6。設任一側面與底面的二面角是 θ，求 cos θ。 | 待改寫 |
| 241 | `geometry_grade11_foundation_007` | [AMC 12A 2012 Problem 12](https://artofproblemsolving.com/wiki/index.php/2012_AMC_12A_Problems/Problem_12) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 平面上有同心圓 x² + y² = 1 與 x² + y² = 4。一個正方形的一邊與小圓相切於點 (0, 1)，且正方形在小圓外側，另外兩… | 待改寫 |
| 242 | `geometry_grade11_foundation_008` | [AMC 12B 2011 Problem 6](https://artofproblemsolving.com/wiki/index.php/2011_AMC_12B_Problems/Problem_6) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'C'} | 從點 A 向圓作兩條切線，切點為 B、C。B、C 將圓分成兩段圓弧，其弧長比是 2:3。求 ∠BAC 的度數。 | 待改寫 |
| 243 | `geometry_grade11_foundation_009` | [IMC Taiwan 2026 複賽 11年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 在空間中，三角形 ABC 的頂點為 A(6,3,4)、B(4,1,3)、C(2,-1,6)。設 ∠BAC 的角平分線與 BC 交於 D，點 … | 待改寫 |
| 244 | `geometry_grade11_foundation_010` | [AMC 10B 2002 Problem 17](https://artofproblemsolving.com/wiki/index.php/2002_AMC_10B_Problems/Problem_17) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'C'} | 正八邊形 ABCDEFGH 的邊長都是 2。求三角形 ADG 的面積。 | 待改寫 |
| 245 | `logic_grade11_foundation_001` | [IMC Taiwan 2026 複賽 11年級 選擇 9](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '1'} | 桌上有 21 枚硬幣，兩人輪流拿 1 枚、2 枚或 3 枚，拿到最後一枚的人獲勝。若先手必勝，第一步應拿幾枚？ | 待改寫 |
| 246 | `logic_grade11_foundation_002` | [IMC Taiwan 2026 複賽 11年級 填充 5](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '4'} | 四個數字卡 1、2、3、4 分別放在四個格子中，每格一張。已知 A 格不是 1，B 格比 A 格大，C 格不是最大的數，D 格是偶數。若 A… | 待改寫 |
| 247 | `logic_grade11_foundation_007` | [AMC 12B 2012 Problem 14](https://artofproblemsolving.com/wiki/index.php/2012_AMC_12B_Problems/Problem_14) | 填數 |  | {'type': 'integer', 'value': '7'} | 先選一個 0 到 999 之間的整數 N 給 Bernardo。每當 Bernardo 拿到一個數，就把它乘以 2 再交給 Silvia；每… | 待改寫 |
| 248 | `logic_grade11_foundation_008` | [AJHSME 1990 Problem 22](https://artofproblemsolving.com/wiki/index.php/1990_AJHSME_Problems/Problem_22) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 幾位學生圍坐成一圈，桌上有 100 顆糖。糖袋依序傳遞，每個人拿到袋子時都取走 1 顆，再傳給下一位。若 Chris 拿走了第 1 顆糖，也… | 待改寫 |
| 249 | `logic_grade11_foundation_009` | [AMC 12B 2006 Problem 19](https://artofproblemsolving.com/wiki/index.php?title=2006_AMC_12B_Problems%2FProblem_19) | 選擇 |  | {'type': 'choice', 'value': 'B'} | Jones 先生有 8 個年齡各不相同的孩子，最大的 9 歲。某天他們看到一個四位數車牌，這個車牌只用了兩種不同數字，而且每種數字各出現兩次… | 待改寫 |
| 250 | `number_theory_grade11_foundation_002` | [IMC Taiwan 2026 複賽 11年級 填充 2](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '-2'} | 求所有整數 n，使得 (n² + n + 1)/(n + 1) 也是整數，並求這些 n 的和。 | 待改寫 |
| 251 | `number_theory_grade11_foundation_003` | [IMC Taiwan 2026 複賽 11年級 選擇 6](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '2'} | 若一個三位數能被 9 整除，且百位、十位、個位數字依次為連續三個正整數（由小到大），求這樣的三位數共有多少個？ | 待改寫 |
| 252 | `number_theory_grade11_foundation_007` | [IMC Taiwan 2026 複賽 11年級 選擇 2](https://imcct.net/UserFiles/news/583/20260413110023_4.pdf) | 填數 |  | {'type': 'integer', 'value': '9'} | 求 1! + 2! + 3! + 4! + ⋯ + 2026! 除以 144 的餘數。 | 待改寫 |
| 253 | `number_theory_grade11_foundation_008` | [AMC 12A 2017 Problem 12](https://artofproblemsolving.com/wiki/index.php/2017_AMC_12A_Problems/Problem_12) | 填數 |  | {'type': 'integer', 'value': '3'} | 有 10 匹馬，編號 1 到 10。第 k 匹馬每 k 分鐘剛好回到起點一次。所有馬在 0 分鐘時同時從起點出發。求最早在某個正整數分鐘時，… | 待改寫 |
| 254 | `number_theory_grade11_foundation_009` | [AMC 12A 2008 Problem 15](https://artofproblemsolving.com/wiki/index.php?title=2008_AMC_12A_Problems%2FProblem_15) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 令 k = 2008² + 2²⁰⁰⁸。求 k² + 2ᵏ 的個位數。 | 待改寫 |
| 255 | `number_theory_grade11_foundation_010` | [AMC 10B 2018 Problem 21](https://artofproblemsolving.com/wiki/index.php/2018_AMC_10B_Problems/Problem_21) | 選擇 |  | {'type': 'choice', 'value': 'C'} | Mary 選了一個四位偶數 n，並把它的所有正因數由小到大寫下來。當她寫到 323 時，下一個比 323 大的因數最小可能是多少？ | 待改寫 |

### 12 年級

| # | 題號 | 原出處 | 題型 | 附圖 | 原答案 | 原題 | 狀態 |
|---|---|---|---|---|---|---|---|
| 256 | `algebra_grade12_foundation_001` | [AMC 12A 2021 Problem 1](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12A_Problems) | 填數 |  | {'type': 'integer', 'value': '50'} | 計算 2⁽¹⁺²⁺³⁾ - (2¹ + 2² + 2³)。 | 待改寫 |
| 257 | `algebra_grade12_foundation_002` | [AMC 12A 2021 Problem 3](https://artofproblemsolving.com/wiki/index.php?title=2021_AMC_12A_Problems%2FProblem_3) | 填數 |  | {'type': 'integer', 'value': '14238'} | 兩個正整數的和是 17402，其中較大的一個末位數字是 0。把這個較大整數末位的 0 去掉後，會得到較小的整數。求兩數的差。 | 待改寫 |
| 258 | `algebra_grade12_foundation_007` | [AMC 12A 2023 Problem 10](https://artofproblemsolving.com/wiki/index.php?title=2023_AMC_12A_Problems%2FProblem_10) | 選擇 |  | {'type': 'choice', 'value': 'D'} | 正實數 x、y 滿足 y³ = x² 與 (y - x)² = 4y²。求 x + y。 | 待改寫 |
| 259 | `algebra_grade12_foundation_008` | [AMC 12A 2024 Problem 12](https://artofproblemsolving.com/wiki/index.php/2024_AMC_12A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'E'} | 等比數列的前三項依序是整數 a、720、b，且 a < 720 < b。若要讓 b 盡可能小，求 b 的各位數字和。 | 待改寫 |
| 260 | `algebra_grade12_foundation_009` | [AMC 12 2000 Problem 12](https://artofproblemsolving.com/wiki/index.php/2000_AMC_12_Problems/Problem_12) | 選擇 |  | {'type': 'choice', 'value': 'E'} | 非負整數 A、M、C 滿足 A + M + C = 12。求 AMC + AM + AC + MC 的最大值。 | 待改寫 |
| 261 | `combinatorics_grade12_foundation_001` | [AMC 12A 2021 Problem 7](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12A_Problems) | 填數 |  | {'type': 'integer', 'value': '60'} | 從標有 1 到 10 的 10 張卡片中任選 3 張，要求所選 3 數的和是偶數。共有多少種選法？ | 待改寫 |
| 262 | `combinatorics_grade12_foundation_002` | [AMC 12B 2021 Problem 10](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12B_Problems) | 填數 |  | {'type': 'integer', 'value': '2'} | 有多少個長度為 8 的 0-1 串，其相鄰兩位都不同？ | 待改寫 |
| 263 | `combinatorics_grade12_foundation_003` | [AMC 12A 2021 Problem 23](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12A_Problems/Problem_23) | 填數 | geometry_scene | {'type': 'integer', 'value': '6'} | 在正六邊形的 6 個頂點中任選 3 點成三角形，問其中鈍角三角形有多少個？ | 待改寫 |
| 264 | `combinatorics_grade12_foundation_007` | [AMC 12B 2023 Problem 23](https://artofproblemsolving.com/wiki/index.php/2023_AMC_12B_Problems/Problem_23) | 填數 |  | {'type': 'integer', 'value': '11'} | 把 n 顆標準六面骰同時擲出，所有可能出現的點數乘積一共會有 936 種不同數值。求 n。 | 待改寫 |
| 265 | `combinatorics_grade12_foundation_008` | [AMC 12A 2025 Problem 23](https://artofproblemsolving.com/wiki/index.php?title=2025_AMC_12A_Problems%2FProblem_23) | 填數 |  | {'type': 'integer', 'value': '9841'} | 稱一個正整數是「合格數」，如果它不含 0、每個數字至多出現一次，而且沒有任何一個數字同時夾在左右兩個比它更大的數字之間。問合格數共有多少個？ | 待改寫 |
| 266 | `combinatorics_grade12_foundation_009` | [AMC 12A 2008 Problem 21](https://artofproblemsolving.com/wiki/index.php/2008_AMC_12A_Problems/Problem_21) | 填數 |  | {'type': 'integer', 'value': '48'} | 若排列 (a1,a2,a3,a4,a5) 是 1,2,3,4,5 的一個重排，且滿足 a1+a2<a4+a5，則稱它為 heavy-tail… | 待改寫 |
| 267 | `geometry_grade12_foundation_001` | [AMC 12B 2021 Problem 5](https://artofproblemsolving.com/wiki/index.php?title=2021_AMC_12B_Problems) | 選擇 | coordinate_plane | {'type': 'choice', 'value': 'D'} | 點 P(a, b) 先以 (1, 5) 為中心逆時針旋轉 90°，再關於直線 y = -x 對稱，結果到達點 (-6, 3)。求 b - a… | 待改寫 |
| 268 | `geometry_grade12_foundation_002` | [AMC 12B 2021 Problem 11](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12B_Problems/Problem_11) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 三角形 ABC 的邊長是 AB = 13、BC = 14、AC = 15。點 P 在 AC 上，且 PC = 10。直線 BP 上恰有兩點 … | 待改寫 |
| 269 | `geometry_grade12_foundation_003` | [AMC 12A 2021 Problem 17](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12A_Problems/Problem_17) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 梯形 ABCD 中，AB ∥ CD，且 BC = CD = 43，另外 AD ⟂ BD。對角線 AC 與 BD 交於 O，P 是 BD 的中… | 待改寫 |
| 270 | `geometry_grade12_foundation_007` | [AMC 12A 2023 Problem 9](https://artofproblemsolving.com/wiki/index.php/2023_AMC_12A_Problems) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'C'} | 一個面積為 2 的正方形內接於一個面積為 3 的正方形中，四周形成四個全等直角三角形。求其中一個陰影直角三角形「較短股 ÷ 較長股」的值。 | 待改寫 |
| 271 | `geometry_grade12_foundation_008` | [AMC 12 2000 Problem 24](https://artofproblemsolving.com/wiki/index.php/2000_AMC_12_Problems/Problem_24) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 弧 AC 的圓心在 B，弧 BC 的圓心在 A，並且這兩段圓弧都與線段 AB 相連，形成對稱圖形。現在有一個小圓同時與這兩段圓弧及線段 AB… | 待改寫 |
| 272 | `geometry_grade12_foundation_009` | [AMC 12A 2008 Problem 13](https://artofproblemsolving.com/wiki/index.php/2008_AMC_12A_Problems/Problem_13) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'B'} | 圓 O 上有兩點 A、B，且 ∠AOB = 60°。一個較小的圓位於扇形 AOB 內部，同時與大圓內切，並且與 OA、OB 兩條半徑都相切。… | 待改寫 |
| 273 | `geometry_grade12_foundation_010` | [AMC 12B 2004 Problem 14](https://artofproblemsolving.com/wiki/index.php/2004_AMC_12B_Problems/Problem_14) | 選擇 | geometry_scene | {'type': 'choice', 'value': 'D'} | 在三角形 ABC 中，AB = 13、AC = 5、BC = 12。點 M 在 AC 上、點 N 在 BC 上，且 CM = CN = 4。… | 待改寫 |
| 274 | `logic_grade12_foundation_001` | [AMC 12B 2021 Problem 8](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12B_Problems) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 在一座島上，騎士永遠說真話，騙子永遠說假話。A 說：「B 是騙子。」B 說：「我們兩人不同類。」問 A 和 B 分別是什麼？ | 待改寫 |
| 275 | `logic_grade12_foundation_007` | [AMC 12A Fall 2021 Problem 22](https://artofproblemsolving.com/wiki/index.php/2021_Fall_AMC_12A_Problems/Problem_22) | 填數 |  | {'type': 'integer', 'value': '148'} | Azar 與 Carl 玩 3×3 井字遊戲。Azar 先下 X，Carl 下 O，兩人輪流下子；只要有人先形成三子連線，遊戲立刻結束。已知… | 待改寫 |
| 276 | `logic_grade12_foundation_008` | [AMC 10 2000 Problem 21](https://artofproblemsolving.com/wiki/index.php/2000_AMC_10_Problems) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 已知所有短吻鱷都是兇猛生物，且有些令人毛骨悚然的爬行物是短吻鱷。判斷下列哪個敘述一定為真： I. 所有短吻鱷都是令人毛骨悚然的爬行物。 II… | 待改寫 |
| 277 | `logic_grade12_foundation_009` | [AMC 12B 2021 Problem 22](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12B_Problems/Problem_22) | 選擇 |  | {'type': 'choice', 'value': 'B'} | Arjun 和 Beth 輪流玩磚塊遊戲。桌上有幾段連續磚牆，玩家每次可以從某一段牆中移走 1 塊磚，或移走相鄰的 2 塊磚；一旦中間被挖空… | 待改寫 |
| 278 | `number_theory_grade12_foundation_001` | [AMC 12B 2021 Problem 1](https://artofproblemsolving.com/wiki/index.php/2021_AMC_12B_Problems) | 填數 |  | {'type': 'integer', 'value': '19'} | 滿足 ｜x｜ < 3π 且 x 是整數的 x 有多少個？ | 待改寫 |
| 279 | `number_theory_grade12_foundation_003` | [AMC 12B Fall 2021 Problem 25](https://artofproblemsolving.com/wiki/index.php/2021_Fall_AMC_12B_Problems/Problem_25) | 填數 |  | {'type': 'integer', 'value': '1'} | 整數 n 有恰好 2021 個正因數。求 n 至少有多少個不同的質因數？ | 待改寫 |
| 280 | `number_theory_grade12_foundation_007` | [AMC 12B 2024 Problem 18](https://artofproblemsolving.com/wiki/index.php/2024_AMC_12B_Problems) | 填數 |  | {'type': 'integer', 'value': '319'} | 費波那契數列滿足 F1 = 1、F2 = 1，且對 n ≥ 3 有 Fn = Fn-1 + Fn-2。求 F2/F1 + F4/F2 + F… | 待改寫 |
| 281 | `number_theory_grade12_foundation_008` | [AMC 12A 2009 Problem 12](https://artofproblemsolving.com/wiki/index.php?title=2009_AMC_12A_Problems%2FProblem_12) | 填數 |  | {'type': 'integer', 'value': '1'} | 小於 1000 的正整數中，有多少個數恰好等於自己各位數字和的 6 倍？ | 待改寫 |
| 282 | `number_theory_grade12_foundation_009` | [AMC 12A 2008 Problem 5](https://artofproblemsolving.com/wiki/index.php/2008_AMC_12A_Problems) | 選擇 |  | {'type': 'choice', 'value': 'B'} | 已知 (2x/3) - (x/6) 是整數。下列哪個敘述一定正確？ | 待改寫 |
| 283 | `number_theory_grade12_foundation_010` | [AMC 12B Fall 2021 Problem 25](https://artofproblemsolving.com/wiki/index.php?title=2021_Fall_AMC_12B_Problems%2FProblem_25) | 選擇 |  | {'type': 'choice', 'value': 'C'} | 對正整數 n，定義 R(n) 為 n 分別除以 2,3,4,5,6,7,8,9,10 的餘數總和。共有多少個兩位正整數 n 滿足 R(n)=… | 待改寫 |
