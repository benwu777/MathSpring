#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
SOURCE = ROOT.join('assets/questions/mixed/kangaroo56_foundation.mixed.v1.json')
GRADE5_TARGET = ROOT.join('assets/questions/mixed/grade5_foundation.mixed.v1.json')
GRADE6_TARGET = ROOT.join('assets/questions/mixed/grade6_foundation.mixed.v1.json')

GRADE5_IDS = %w[
  mixed_kangaroo56_foundation_001
  mixed_kangaroo56_foundation_002
  mixed_kangaroo56_foundation_003
  mixed_kangaroo56_foundation_004
  mixed_kangaroo56_foundation_005
  mixed_kangaroo56_foundation_006
  mixed_kangaroo56_foundation_011
  mixed_kangaroo56_foundation_012
  mixed_kangaroo56_foundation_013
  mixed_kangaroo56_foundation_016
  mixed_kangaroo56_foundation_017
  mixed_kangaroo56_foundation_018
  mixed_kangaroo56_foundation_019
  mixed_kangaroo56_foundation_020
  mixed_kangaroo56_foundation_022
  mixed_kangaroo56_foundation_023
  mixed_kangaroo56_foundation_029
].freeze

def rewrite_pack(source:, level_stage:, questions:)
  source.merge(
    'levelStage' => level_stage,
    'questions' => questions.each_with_index.map do |question, index|
      question.merge(
        'id' => "mixed_#{level_stage}_foundation_#{format('%03d', index + 1)}",
        'levelStage' => level_stage
      )
    end
  )
end

payload = JSON.parse(SOURCE.read)
grade5_questions, grade6_questions = payload.fetch('questions').partition do |question|
  GRADE5_IDS.include?(question.fetch('id'))
end

GRADE5_TARGET.write(
  JSON.pretty_generate(
    rewrite_pack(source: payload, level_stage: 'grade5', questions: grade5_questions)
  ) + "\n"
)

GRADE6_TARGET.write(
  JSON.pretty_generate(
    rewrite_pack(source: payload, level_stage: 'grade6', questions: grade6_questions)
  ) + "\n"
)

puts "grade5 mixed: #{grade5_questions.length}"
puts "grade6 mixed: #{grade6_questions.length}"
