# 依 question id 設定 reviewStatus，逐行掃描、保留原格式。
# 用法：ruby scripts/set_review_status.rb <json檔> <id>=<status> [<id>=<status> ...]
# 例：ruby scripts/set_review_status.rb assets/questions/algebra/grade7_foundation.algebra.v1.json \
#       algebra_grade7_foundation_001=ok algebra_grade7_foundation_005=blocked

path = ARGV.shift or abort "缺少 json 檔路徑"
mapping = {}
ARGV.each do |pair|
  id, status = pair.split("=", 2)
  abort "參數格式錯誤：#{pair}" unless id && status
  mapping[id] = status
end
abort "未提供任何 id=status" if mapping.empty?

valid = %w[pending needs_fix fixed ok blocked]
mapping.each_value { |s| abort "非法狀態：#{s}" unless valid.include?(s) }

lines = File.readlines(path)
current_id = nil
applied = Hash.new(0)

lines.map! do |line|
  if (m = line.match(/^\s*"id":\s*"([^"]+)"/))
    current_id = m[1]
    next line
  end
  if line.match(/^\s*"reviewStatus":/) && current_id && mapping.key?(current_id)
    applied[current_id] += 1
    indent = line[/^\s*/]
    next "#{indent}\"reviewStatus\": \"#{mapping[current_id]}\"\n"
  end
  line
end

missing = mapping.keys - applied.keys
abort "以下 id 未在檔案中找到對應 reviewStatus：#{missing.join(', ')}" unless missing.empty?
dup = applied.select { |_, n| n > 1 }
abort "以下 id 命中多於一次（結構異常）：#{dup.keys.join(', ')}" unless dup.empty?

File.write(path, lines.join)
mapping.each { |id, s| puts "#{id} -> #{s}" }
