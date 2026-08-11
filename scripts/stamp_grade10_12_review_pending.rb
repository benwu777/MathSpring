# 一次性腳本：為 grade10-12 題目補上 reviewStatus: "pending"，堵住 gating fail-open 漏洞。
# 錨點用每題必有的 "id" 行（對 compact 與 pretty 兩種格式都可靠），插在其後。
# 防呆：每檔實際插入數必須等於該檔題數（= id 行數），否則中止不寫檔。

require "pathname"

root = Pathname.new(File.expand_path("..", __dir__))
targets = Dir.glob(root.join("assets/questions/*/grade1[012]_*.json")).sort

total_inserted = 0
targets.each do |path|
  text = File.read(path)

  question_count = text.scan(/^      "id":\s*"/).length
  already = text.scan(/"reviewStatus":/).length
  if already > 0
    abort "已有 reviewStatus，跳過避免重複：#{path}（#{already} 筆）"
  end

  inserted = 0
  text = text.gsub(/^(      "id":\s*"[^"]+",\n)/) do |m|
    inserted += 1
    "#{m}      \"reviewStatus\": \"pending\",\n"
  end

  if inserted != question_count
    abort "插入數(#{inserted}) 不等於題數(#{question_count})：#{path}"
  end

  File.write(path, text)
  total_inserted += inserted
  puts "#{File.basename(path)}: +#{inserted}"
end

puts "---"
puts "共 #{targets.length} 檔，插入 #{total_inserted} 筆 reviewStatus: pending"
