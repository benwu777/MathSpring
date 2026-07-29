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
  'arithmetic_grade2_foundation_006' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩堆糖一共有 18 顆。若從比較多的那堆拿 2 顆到比較少的那堆後，原本比較少的那堆反而會比另一堆多 2 顆。原來比較多的那堆有幾顆？',
        en: 'Two piles of candies have 18 candies in total. If 2 candies are moved from the larger pile to the smaller pile, the pile that was originally smaller will end up with 2 more candies than the other pile. How many candies were originally in the larger pile?'
      ),
      'answer' => loc(zh_hant: '答案是 10 顆。', en: 'The answer is 10.'),
      'solutionSteps' => steps(
        ['設原來較多的一堆有 x 顆，較少的一堆有 18 - x 顆。', 'Let the larger pile originally have x candies, so the smaller pile has 18 - x candies.'],
        ['移動 2 顆後，較多的一堆變成 x - 2，較少的一堆變成 20 - x。', 'After moving 2 candies, the larger pile becomes x - 2 and the smaller pile becomes 20 - x.'],
        ['題目說這時原本較少的那堆會多 2 顆，所以 20 - x = (x - 2) + 2，也就是 20 - x = x。', 'The problem says the originally smaller pile is then 2 candies greater, so 20 - x = (x - 2) + 2, which simplifies to 20 - x = x.'],
        ['因此 2x = 20，得到 x = 10。', 'Thus 2x = 20, so x = 10.']
      )
    ).merge(integer_answer(10, digits: 2))
  end,
  'arithmetic_grade4_foundation_007' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '兩盒球一共有 46 顆。若從球比較多的那盒拿 5 顆到另一盒後，球比較多的那盒仍然會比另一盒多 4 顆。原來球比較多的那盒有幾顆？',
        en: 'Two boxes contain 46 balls in total. If 5 balls are moved from the fuller box to the other box, the fuller box still has 4 more balls than the other box. How many balls were originally in the fuller box?'
      ),
      'answer' => loc(zh_hant: '答案是 30 顆。', en: 'The answer is 30.'),
      'solutionSteps' => steps(
        ['設原來較多的那盒有 x 顆，另一盒就有 46 - x 顆。', 'Let the fuller box originally have x balls, so the other box has 46 - x balls.'],
        ['移動 5 顆後，兩盒分別變成 x - 5 和 51 - x。', 'After moving 5 balls, the boxes contain x - 5 and 51 - x balls.'],
        ['題目說此時前者仍比後者多 4 顆，所以 x - 5 = (51 - x) + 4。', 'The problem says the former still has 4 more balls, so x - 5 = (51 - x) + 4.'],
        ['整理得 2x = 60，因此 x = 30。', 'This simplifies to 2x = 60, so x = 30.']
      )
    ).merge(integer_answer(30, digits: 2))
  end,
  'arithmetic_grade4_foundation_044' => lambda do |q|
    q.merge(
      'prompt' => loc(
        zh_hant: '一位小朋友要走上 6 階樓梯。每一步可以走 1 階、2 階或 3 階，但 3 階只能走一次。共有幾種不同走法？',
        en: 'A child wants to climb 6 steps. Each move can cover 1, 2, or 3 steps, but a 3-step move may be used at most once. How many different ways are there?'
      ),
      'answer' => loc(zh_hant: '答案是 23 種。', en: 'The answer is 23.'),
      'solutionSteps' => steps(
        ['先看完全不用 3 階的走法，也就是只用 1 階和 2 階走上 6 階，共有 13 種。', 'First count the ways that do not use a 3-step move at all. Using only 1-step and 2-step moves to make 6 gives 13 ways.'],
        ['再看剛好用一次 3 階的走法。扣掉這 3 階後，還剩 3 階要用 1 階和 2 階完成。', 'Now count the ways that use exactly one 3-step move. After removing that 3-step move, there are 3 steps left to make using 1-step and 2-step moves.'],
        ['補成 3 階的方法有 1+1+1、1+2、2+1。把那一次 3 階插入這三類走法中，分別有 4、3、3 種位置，所以共 10 種。', 'The ways to make 3 are 1+1+1, 1+2, and 2+1. Inserting one 3-step move into these patterns gives 4, 3, and 3 positions respectively, for 10 ways total.'],
        ['因此全部走法共有 13 + 10 = 23 種。', 'So the total number of ways is 13 + 10 = 23.']
      )
    ).merge(integer_answer(23, digits: 2))
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
