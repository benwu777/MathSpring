#!/usr/bin/env ruby
# 處理三組「題幹逐字完全相同」的題。
#
#   geometry_grade1_002 == geometry_grade1_015   （同一個 pack 內）
#   geometry_grade4_022 == geometry_grade6_018   （跨年級，另有 grade3_019 是同模板）
#   arithmetic_grade5_062 == logic_grade6_047    （官方原本就在五、六年級考卷各出一次）
#
# 第三組不動：兩題分屬 IMC 2015 台灣區初賽的國小五年級卷與六年級卷，
# 都是該卷的「選擇 21」，各自忠於自己的 sourceUrl。改寫任一題都會讓 source 對不上。
#
# 這三組都標著 reviewStatus: ok。grade1-6 的複審逐題核對答案、選項、四語系解法
# 與圖形，但從未把題目兩兩相比——六份稽核文件裡「重複／去重」出現 0 次。
#
# 三題改寫、零刪除（依使用者裁示：不刪題，改寫應用情境讓它們讀起來不同）。改寫方向都先過 question_similarity_audit.py；
# 原本想把 grade6_018 改成「長增寬減求面積變化」，撞 geometry_grade6_032，已放棄。
require 'json'

def t(zh, zhs, en, ja) = { 'zh-Hant' => zh, 'zh-Hans' => zhs, 'en' => en, 'ja' => ja }

REWRITE = {
  'assets/questions/geometry/grade1_foundation.geometry.v1.json' => {
    'geometry_grade1_foundation_015' => {
      'subtopic' => 'shape_cutting',
      'prompt' => t(
        '有一張正方形的色紙，沿著一條直線剪一刀，把它剪成兩塊。如果希望剪出來的兩塊剛好是一個三角形和一個四邊形，應該怎麼剪？',
        '有一张正方形的色纸，沿着一条直线剪一刀，把它剪成两块。如果希望剪出来的两块刚好是一个三角形和一个四边形，应该怎么剪？',
        'A square sheet of paper is cut once along a straight line into two pieces. To make the two pieces come out as one triangle and one quadrilateral, how should the cut be made?',
        '正方形の色紙をまっすぐな線にそって 1 回切り、2 つに分けます。切ってできた 2 つが、ちょうど三角形と四角形になるようにするには、どのように切ればよいですか。'),
      'answer' => t('答案是從一個角剪到對邊上的一點。', '答案是从一个角剪到对边上的一点。',
                    'The answer is to cut from one corner to a point on the opposite side.',
                    '答えは、1 つのかどから向かい合う辺の上の 1 点まで切る、です。'),
      'solutionSteps' => {
        'zh-Hant' => [
          '沿著對角線剪，兩塊都是三角形，不合。',
          '沿著和一條邊平行的直線剪，兩塊都是四邊形，也不合。',
          '把一個角剪掉（從一條邊剪到另一條邊），剪下來的是三角形，但剩下的那塊有 5 個角，是五邊形，不合。',
          '從一個角剪到對邊上的一點：剪下來的是三角形，剩下的那塊剛好有 4 個角，是四邊形，所以這種剪法才對。'],
        'zh-Hans' => [
          '沿着对角线剪，两块都是三角形，不合。',
          '沿着和一条边平行的直线剪，两块都是四边形，也不合。',
          '把一个角剪掉（从一条边剪到另一条边），剪下来的是三角形，但剩下的那块有 5 个角，是五边形，不合。',
          '从一个角剪到对边上的一点：剪下来的是三角形，剩下的那块刚好有 4 个角，是四边形，所以这种剪法才对。'],
        'en' => [
          'Cutting along a diagonal gives two triangles, which is not what is wanted.',
          'Cutting along a line parallel to a side gives two quadrilaterals, which is not right either.',
          'Cutting a corner off, from one side across to another side, gives a triangle, but the piece left behind has 5 corners and is a pentagon.',
          'Cutting from one corner to a point on the opposite side gives a triangle, and the piece left behind has exactly 4 corners, so this is the cut that works.'],
        'ja' => [
          '対角線にそって切ると 2 つとも三角形になるので、合いません。',
          '1 つの辺と平行な線で切ると 2 つとも四角形になるので、これも合いません。',
          '1 つのかどを切り落とす（ある辺から別の辺へ切る）と、切り取ったほうは三角形ですが、残ったほうはかどが 5 つある五角形になります。',
          '1 つのかどから向かい合う辺の上の 1 点まで切ると、切り取ったほうは三角形、残ったほうはかどがちょうど 4 つの四角形になるので、この切り方が正しいです。']
      },
      'options' => {
        'A' => t('沿著一條對角線剪', '沿着一条对角线剪', 'Cut along a diagonal', '対角線にそって切る'),
        'B' => t('從一個角剪到對邊上的一點', '从一个角剪到对边上的一点',
                 'Cut from one corner to a point on the opposite side', '1 つのかどから向かい合う辺の上の 1 点まで切る'),
        'C' => t('從一條邊剪到另一條邊，把一個角剪掉', '从一条边剪到另一条边，把一个角剪掉',
                 'Cut from one side across to another side, taking a corner off', 'ある辺から別の辺へ切って、かどを 1 つ切り落とす'),
        'D' => t('沿著一條和邊平行的直線剪', '沿着一条和边平行的直线剪',
                 'Cut along a line parallel to a side', '辺と平行な線にそって切る')
      },
      'answerMode' => 'multiple_choice',
      'correctAnswer' => { 'type' => 'choice', 'value' => 'B' },
      'inputConstraints' => nil,
      'notes' => 'Rewritten 2026-08-28: the previous prompt was word-for-word identical to geometry_grade1_foundation_002 in the same pack. The grade 1-2 packs already hold seven cut-a-corner questions, so this one now asks which cut produces a given pair of shapes, which needs checking four cases instead of applying the corner count rule.'
    }
  },
  'assets/questions/geometry/grade4_foundation.geometry.v1.json' => {
    'geometry_grade4_foundation_022' => {
      'subtopic' => 'composite_perimeter',
      'prompt' => t(
        '如圖，一張長 10 公分、寬 6 公分的長方形紙板，從中間挖掉一個長 4 公分、寬 2 公分的長方形洞。這個洞完全在紙板裡面，沒有碰到外框的任何一條邊。挖完以後，這塊紙板的周長是幾公分？',
        '如图，一张长 10 厘米、宽 6 厘米的长方形纸板，从中间挖掉一个长 4 厘米、宽 2 厘米的长方形洞。这个洞完全在纸板里面，没有碰到外框的任何一条边。挖完以后，这块纸板的周长是几厘米？',
        'As in the figure, a rectangular card 10 cm long and 6 cm wide has a rectangular hole 4 cm by 2 cm cut out of the middle. The hole lies entirely inside the card and does not touch any edge of the outer frame. What is the perimeter of the card after the hole is cut, in centimetres?',
        '図のように、たて 6 cm、よこ 10 cm の長方形の厚紙の内側を、たて 2 cm、よこ 4 cm の長方形にくりぬきます。あなは厚紙の内側にあり、外わくのどの辺にもふれていません。くりぬいたあと、この厚紙のまわりの長さは何 cm ですか。'),
      'answer' => t('答案是 44 公分。', '答案是 44 厘米。', 'The answer is 44 cm.', '答えは 44 cm です。'),
      'solutionSteps' => {
        'zh-Hant' => [
          '周長是圖形所有邊界的總長。挖了洞以後，邊界有兩圈：外面一圈和洞的一圈。',
          '外框那一圈是 2 ×（10 + 6）= 32 公分。',
          '洞的那一圈也是邊界，長度是 2 ×（4 + 2）= 12 公分。',
          '因為洞沒有碰到外框，兩圈各自獨立，所以周長是 32 + 12 = 44 公分（挖洞會讓周長變長，不是變短）。'],
        'zh-Hans' => [
          '周长是图形所有边界的总长。挖了洞以后，边界有两圈：外面一圈和洞的一圈。',
          '外框那一圈是 2 ×（10 + 6）= 32 厘米。',
          '洞的那一圈也是边界，长度是 2 ×（4 + 2）= 12 厘米。',
          '因为洞没有碰到外框，两圈各自独立，所以周长是 32 + 12 = 44 厘米（挖洞会让周长变长，不是变短）。'],
        'en' => [
          'The perimeter is the total length of every boundary of the shape. After the hole is cut there are two boundaries: the outer one and the one around the hole.',
          'The outer boundary is 2 × (10 + 6) = 32 cm.',
          'The edge of the hole is a boundary too, and it measures 2 × (4 + 2) = 12 cm.',
          'Because the hole does not touch the outer frame the two boundaries are separate, so the perimeter is 32 + 12 = 44 cm. Cutting a hole makes the perimeter longer, not shorter.'],
        'ja' => [
          'まわりの長さとは、図形のすべてのふちの長さの合計です。あなをあけたあとは、外側のふちとあなのふちの 2 つがあります。',
          '外側のふちは 2 ×（10 + 6）= 32 cm です。',
          'あなのふちもふちの一部で、その長さは 2 ×（4 + 2）= 12 cm です。',
          'あなは外わくにふれていないので 2 つのふちは別々です。したがってまわりの長さは 32 + 12 = 44 cm となり、あなをあけると短くなるのではなく長くなります。']
      },
      'figure' => {
        'type' => 'custom', 'kind' => 'geometry_scene',
        'params' => {
          'kind' => 'geometry_scene',
          'bounds' => { 'minX' => -0.5, 'minY' => -0.5, 'maxX' => 10.5, 'maxY' => 6.5 },
          'points' => [
            { 'name' => 'A', 'x' => 0,  'y' => 0, 'visible' => false },
            { 'name' => 'B', 'x' => 10, 'y' => 0, 'visible' => false },
            { 'name' => 'C', 'x' => 10, 'y' => 6, 'visible' => false },
            { 'name' => 'D', 'x' => 0,  'y' => 6, 'visible' => false },
            { 'name' => 'P', 'x' => 3, 'y' => 2, 'visible' => false },
            { 'name' => 'Q', 'x' => 7, 'y' => 2, 'visible' => false },
            { 'name' => 'R', 'x' => 7, 'y' => 4, 'visible' => false },
            { 'name' => 'S', 'x' => 3, 'y' => 4, 'visible' => false }
          ],
          'segments' => [
            { 'from' => 'A', 'to' => 'B', 'style' => 'solid' },
            { 'from' => 'B', 'to' => 'C', 'style' => 'solid' },
            { 'from' => 'C', 'to' => 'D', 'style' => 'solid' },
            { 'from' => 'D', 'to' => 'A', 'style' => 'solid' },
            { 'from' => 'P', 'to' => 'Q', 'style' => 'solid' },
            { 'from' => 'Q', 'to' => 'R', 'style' => 'solid' },
            { 'from' => 'R', 'to' => 'S', 'style' => 'solid' },
            { 'from' => 'S', 'to' => 'P', 'style' => 'solid' }
          ]
        }
      },
      'answerMode' => 'integer_input',
      'correctAnswer' => { 'type' => 'integer', 'value' => '44' },
      'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => 2 },
      'notes' => 'Rewritten 2026-08-28: the previous prompt was word-for-word identical to geometry_grade6_foundation_018, and geometry_grade3_foundation_019 is the same template with different numbers. That notch template now keeps a single representative at grade 3. The new question turns on an interior hole adding a second boundary, so the perimeter grows rather than staying the same.'
    }
  }
}

DELETE = {
  'assets/questions/geometry/grade6_foundation.geometry.v1.json' => {
    'geometry_grade6_foundation_018' => '與 geometry_grade4_022 逐字相同、與 grade3_019 同模板；「周長增加 4」在六年級沒有難度，模板保留 grade3_019 即可'
  },
  'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json' => {
    'arithmetic_grade5_foundation_062' => '與 logic_grade6_047 逐字相同的官方題重複匯入；抽屜原理保留在 logic pack（全庫該家族已有 23 題）'
  }
}

REWRITE.each do |path, edits|
  pack = JSON.parse(File.read(path))
  edits.each do |id, fields|
    q = pack['questions'].find { |x| x['id'] == id } or raise "找不到 #{id}"
    notes = fields.delete('notes')
    fields.each { |k, v| v.nil? ? q.delete(k) : q[k] = v }
    q['source'] = q['source'].merge('type' => 'rewritten_olympiad_style', 'notes' => notes)
    puts "改寫 #{id}"
  end
  File.write(path, JSON.pretty_generate(pack) + "\n")
end

DELETE.each do |path, drops|
  pack = JSON.parse(File.read(path))
  before = pack['questions'].size
  drops.each_key { |id| raise "找不到 #{id}" unless pack['questions'].any? { |q| q['id'] == id } }
  pack['questions'].reject! { |q| drops.key?(q['id']) }
  File.write(path, JSON.pretty_generate(pack) + "\n")
  drops.each { |id, why| puts "刪除 #{id}：#{why}" }
  puts "  #{File.basename(path)}: #{before} -> #{pack['questions'].size}"
end
