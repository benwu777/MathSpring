# 紙娃娃素材生成規則

給「有生圖能力的 session」用。目標是產出可以直接疊進 `AvatarPreview` 的圖層，
不需要事後手工對位。**先讀本檔再生圖**，規格不符的素材一律不收。

## 目前缺什麼

| 部位 | 女生 | 男生 | 狀態 |
| --- | ---: | ---: | --- |
| 膚色 | — | — | 以基底疊色實作，不需素材 |
| 臉型 | 5 | 5 | 齊，由 `scripts/derive_avatar_layers.py` 從基準臉衍生 |
| 髮型 | 5 | 2 | **男生缺 3 款**，目前用鏡像與縮放頂替 |
| 眼睛 | 5 | 5 | 齊 |
| 鼻子 | 5 | 5 | 齊 |
| 嘴巴 | 7 | 5 | 齊 |

只有髮型需要生圖：髮型無法從既有圖層變形生出新造型（鮑伯頭再怎麼變形還是鮑伯頭）。
其餘部位若要再擴充，優先用衍生腳本改形狀，不要重生。

男生建議補的三款：**中長蓋耳髮**、**自然捲短髮**、**旁分長瀏海**。三款都要跟既有兩款
（短瀏海分邊、蓬鬆碎髮）一眼可分。

## 畫布契約（不可違反）

- 尺寸固定 `1254 x 1254`，正方形，PNG，直式 sRGB + alpha。
- 圖層只畫自己那個部位，其餘全透明。**不可裁切、不可縮放、不可置中對齊**——
  位置就是對位資訊，裁掉就再也對不回去。
- 一張圖只有一個部位：髮型圖層不可出現臉、眼、眉、鼻、嘴、脖子或背景。

## 對位座標（量自已驗收的圖層）

以 1254 畫布的絕對像素表示。新圖層必須落在同一位置。

| 項目 | 女生 | 男生 |
| --- | --- | --- |
| 臉輪廓 | x 247–1008、y 246–1161 | x 205–1049、y 151–1197 |
| 耳朵高度 | y 640–800 | y 580–810 |
| 下巴 | y ≈ 1020 | y ≈ 1000 |
| 左右眼中心 | (392, 641)、(862, 641) | (420, 624)、(834, 624) |
| 眉毛帶 | y 486–560 | y 490–560 |
| 鼻子 | 81×75，中心 (627, 680) | 117×97，中心 (627, 640) |
| 嘴巴 | 223×63，中心 (627, 827) | 234×61，中心 (627, 663) |
| 髮型佔位 | 約 x 194–1055、y 106–987 | 約 x 172–1112、y 159–905 |

髮際線與瀏海：**瀏海最低點不可低於眉毛帶上緣**（女生 y 486、男生 y 490）。
頭髮可以往上、左、右長，但不可蓋住眼睛、鼻子、嘴巴。

程式在疊圖時只會對男生髮型整層上移 `-0.1`（畫布高度比例）以對齊來源畫布，
其他部位不會再移動，所以生圖時就要畫在上表的位置。

## 生圖 prompt 要件

每張都要寫進 prompt：

1. 以 `assets/avatars/<girl|boy>/reference/` 的參考頭像當幾何依據，保持同一畫風
   （平塗插畫、深棕髮、柔和高光、細線稿）。
2. 只輸出指定部位，其他部位「absent」「transparent」。
3. 指定該部位的對位座標與尺寸範圍（照上表）。
4. 明確禁止：背景、色塊、方框、棋盤格、浮水印、文字、陰影投影到臉上。
5. 若模型無法直接輸出透明背景，改用純綠 `rgb(3,243,3)` 去背色，檔名存成
   `<layer>-chroma.png`，之後用去背腳本處理。

## 去背與驗收

```sh
# 1. 去背（會把綠色溢色壓回紅藍水準，避免髮絲殘留綠邊）
python3 scripts/remove_chroma_key.py assets/avatars/boy/hair/hair-03-chroma.png \
                                     assets/avatars/boy/hair/hair-03.png

# 2. 尺寸與 alpha
magick identify -format '%wx%h %[channels]\n' assets/avatars/boy/hair/hair-03.png
#    必須是 1254x1254 srgba

# 3. 殘留綠邊：所有不透明像素都必須 G - max(R,B) <= 0
python3 - <<'PY'
from PIL import Image
im = Image.open('assets/avatars/boy/hair/hair-03.png').convert('RGBA')
worst = max((g - max(r, b)) for r, g, b, a in im.getdata() if a > 16)
print('max green spill:', worst)
PY

# 4. 疊圖看圖：換上新髮型後，五官不可被遮、不可位移
sh scripts/compose_girl_avatar_preview.sh <hair> <nose> <mouth> /tmp/preview.png
```

四項都過才可以進 catalog。

## 接進 App

1. 檔名照既有規則：`assets/avatars/<girl|boy>/<part>/<part>-NN.png`。
2. 在 `lib/models/avatar_configuration.dart` 的清單加 id `<girl|boy>_<part>_NN`。
3. 如果這個 id 取代的是原本共用圖層的頂替方案，順手把
   `lib/services/avatar_asset_catalog.dart` 裡對應的 `_sharedLayerSource` 與
   `_treatments` 條目刪掉——測試會檢查同一部位的選項不可共用圖層。
4. `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart`
5. 逐張看圖確認（規格見 `docs/paper-doll-avatar.md` 的驗收清單）。

## 為什麼不用縮放頂替

同一張圖等比縮放不是新造型，使用者一眼看得出來是同一個東西。
現行測試 `face, eyes, nose, and mouth options each own a separate layer` 會擋下
「同部位兩個選項指向同一個檔案」與「靠 runtime 變形冒充造型」。
髮型是唯一還允許共用的部位，補齊素材後這個豁免要一併移除。
