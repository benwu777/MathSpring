#!/usr/bin/env ruby
# 移除本次擴充中混入的弱變形題。
#
# 這 9 題都是本 session 新增的，事後用「重疊係數」重掃才發現撞到既有題。
# 原本的相似度閘門用 Jaccard，對「同一題但一邊寫得比較囉嗦」很脆弱：
# 頁碼題 arithmetic_grade4_073 vs arithmetic_grade6_009 的 Jaccard 只有 0.27
# （低於 0.40 門檻），重疊係數卻是 0.62。工具已補上這個指標。
require 'json'

DROP = {
  'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json' => {
    'arithmetic_grade1_foundation_070' => '三個連續整數的和求最大數，撞 arithmetic_grade5_014（同題換數字）'
  },
  'assets/questions/logic/grade1_foundation.logic.v1.json' => {
    'logic_grade1_foundation_053' => '抽屜原理拿襪子，撞 logic_grade4_011（手套版，連答案都是 5）'
  },
  'assets/questions/geometry/grade2_foundation.geometry.v1.json' => {
    'geometry_grade2_foundation_050' => '長方形挖一角求剩餘面積，撞 geometry_grade6_011、grade4_013、grade3_020'
  },
  'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json' => {
    'arithmetic_grade3_foundation_077' => '紅藍球個數比 3:5，撞 arithmetic_grade6_001（同比例）'
  },
  'assets/questions/geometry/grade3_foundation.geometry.v1.json' => {
    'geometry_grade3_foundation_056' => '三角形內角比求最大角，撞 geometry_grade7_016（同題換比例）',
    'geometry_grade3_foundation_050' => '長寬各放大求面積倍數，撞 geometry_grade6_026（同題換倍率）'
  },
  'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json' => {
    'arithmetic_grade4_foundation_073' => '頁碼共用幾個數字，撞 arithmetic_grade6_009、grade5_005、grade5_019',
    'arithmetic_grade4_foundation_075' => '火車過橋，撞本次同時新增的 arithmetic_grade5_073（只換橋長）',
    'arithmetic_grade4_foundation_076' => '兩位數數字和為定值有幾個，撞本次同時新增的 arithmetic_grade5_069（後者多一層倍數篩選）'
  },
  'assets/questions/geometry/grade4_foundation.geometry.v1.json' => {
    'geometry_grade4_foundation_049' => '正方形中點四邊形面積倍數，撞 geometry_grade10_015（Varignon，連「面積減半」的結論都相同）'
  }
}

total = 0
DROP.each do |path, drops|
  pack = JSON.parse(File.read(path))
  before = pack['questions'].size
  drops.each_key { |id| raise "找不到 #{id}" unless pack['questions'].any? { |q| q['id'] == id } }
  pack['questions'].reject! { |q| drops.key?(q['id']) }
  File.write(path, JSON.pretty_generate(pack) + "\n")
  drops.each { |id, why| puts "  - #{id}：#{why}" }
  puts "#{File.basename(path)}: #{before} -> #{pack['questions'].size}"
  total += drops.size
end
puts "共移除 #{total} 題"
