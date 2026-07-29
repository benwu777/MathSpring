#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
QUESTION_FILES = Dir[ROOT.join('assets/questions/**/*.json').to_s]

def loc(zh_hant:, en:)
  {
    'zh-Hant' => zh_hant,
    'zh-Hans' => zh_hant,
    'en' => en,
    'ja' => en
  }
end

def steps(*pairs)
  {
    'zh-Hant' => pairs.map(&:first),
    'zh-Hans' => pairs.map(&:first),
    'en' => pairs.map(&:last),
    'ja' => pairs.map(&:last)
  }
end

def integer_answer(value, digits:)
  {
    'correctAnswer' => {'type' => 'integer', 'value' => value.to_s},
    'inputConstraints' => {'allowNegative' => false, 'maxDigits' => digits},
    'answerMode' => 'integer_input'
  }
end

REPLACEMENTS = {
  'arithmetic_grade4_foundation_007' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩盒球一共有 46 顆。若從球比較多的那盒拿 5 顆到另一盒後，收到球的那盒球數正好變成原來的 2 倍。原來球比較多的那盒有幾顆？',
        en: 'Two boxes contain 46 balls in total. If 5 balls are moved from the fuller box to the other box, the receiving box then has exactly twice as many balls as it had originally. How many balls were originally in the fuller box?'
      ),
      'answer' => loc(zh_hant: '答案是 41 顆。', en: 'The answer is 41.'),
      'solutionSteps' => steps(
        ['收到球的那盒拿到 5 顆後，變成原來的 2 倍，所以原來那盒有 5 顆。', 'The receiving box becomes twice its original amount after receiving 5 balls, so it originally had 5 balls.'],
        ['兩盒一共有 46 顆，因此另一盒原來有 46 - 5 = 41 顆。', 'Since the total is 46 balls, the other box originally had 46 - 5 = 41 balls.'],
        ['這一盒原本就是較多的那盒，所以答案是 41。', 'That box was the fuller one, so the answer is 41.']
      )
    ).merge(integer_answer(41, digits: 2))
  end,
  'arithmetic_grade6_foundation_008' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '甲盒裡的球數是乙盒的 4 倍。若從甲盒拿 18 顆到乙盒後，甲盒仍然會比乙盒多 12 顆。甲盒原來有幾顆球？',
        en: 'Box A has 4 times as many balls as Box B. If 18 balls are moved from Box A to Box B, Box A still has 12 more balls than Box B. How many balls did Box A originally have?'
      ),
      'answer' => loc(zh_hant: '答案是 64 顆。', en: 'The answer is 64.'),
      'solutionSteps' => steps(
        ['設乙盒原來有 x 顆，則甲盒原來有 4x 顆。', 'Let Box B originally have x balls. Then Box A originally has 4x balls.'],
        ['移動 18 顆後，甲盒變成 4x - 18，乙盒變成 x + 18。', 'After moving 18 balls, Box A has 4x - 18 and Box B has x + 18.'],
        ['題目說此時甲盒仍比乙盒多 12 顆，所以 4x - 18 = (x + 18) + 12。', 'The problem says Box A still has 12 more balls, so 4x - 18 = (x + 18) + 12.'],
        ['整理得 4x - 18 = x + 30，所以 3x = 48，x = 16。', 'This simplifies to 4x - 18 = x + 30, so 3x = 48 and x = 16.'],
        ['因此甲盒原來有 4 × 16 = 64 顆。', 'Therefore Box A originally had 4 × 16 = 64 balls.']
      )
    ).merge(integer_answer(64, digits: 2))
  end
}.freeze

QUESTION_FILES.each do |path|
  next unless path.include?('/assets/questions/')

  payload = JSON.parse(File.read(path))
  next unless payload['questions']

  changed = false
  payload['questions'].map! do |question|
    replacement = REPLACEMENTS[question['id']]
    if replacement
      changed = true
      replacement.call(question)
    else
      question
    end
  end
  next unless changed

  File.write(path, JSON.pretty_generate(payload) + "\n")
  puts "updated #{File.basename(path)}"
end
