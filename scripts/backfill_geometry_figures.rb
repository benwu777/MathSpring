#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'pathname'

ROOT = Pathname.new(__dir__).join('..').expand_path
GEOMETRY_FILES = ROOT.join('assets/questions/geometry').glob('*.json').sort

def shape_figure(shape, labels = {})
  {
    'type' => 'custom',
    'kind' => 'shape_diagram',
    'params' => {
      'shape' => shape,
      'labels' => labels
    }
  }
end

def none_figure
  {
    'type' => 'custom',
    'kind' => 'none',
    'params' => {}
  }
end

def grid_figure(rows:, cols:, filled_cells:, cell_labels: {})
  {
    'type' => 'custom',
    'kind' => 'composite_grid_shape',
    'params' => {
      'rows' => rows,
      'cols' => cols,
      'filledCells' => filled_cells,
      'cellLabels' => cell_labels
    }
  }
end

def coordinate_figure(point:, max_x:, max_y:, path: nil, highlight_point: nil)
  params = {
    'maxX' => max_x,
    'maxY' => max_y,
    'showGrid' => true,
    'points' => [point]
  }
  params['path'] = path if path
  params['highlightPoint'] = highlight_point if highlight_point
  {
    'type' => 'custom',
    'kind' => 'coordinate_plane',
    'params' => params
  }
end

def l_shape
  grid_figure(
    rows: 2,
    cols: 2,
    filled_cells: [[0, 0], [1, 0], [1, 1]]
  )
end

def missing_corner_square
  grid_figure(
    rows: 2,
    cols: 2,
    filled_cells: [[0, 0], [0, 1], [1, 0]]
  )
end

def row_of_four
  grid_figure(
    rows: 1,
    cols: 4,
    filled_cells: [[0, 0], [0, 1], [0, 2], [0, 3]]
  )
end

def square_two_by_two
  grid_figure(
    rows: 2,
    cols: 2,
    filled_cells: [[0, 0], [0, 1], [1, 0], [1, 1]]
  )
end

def cross_shape
  grid_figure(
    rows: 3,
    cols: 3,
    filled_cells: [[0, 1], [1, 0], [1, 1], [1, 2], [2, 1]]
  )
end

def border_square
  filled_cells = []
  4.times do |row|
    4.times do |col|
      filled_cells << [row, col] if row.zero? || row == 3 || col.zero? || col == 3
    end
  end
  grid_figure(rows: 4, cols: 4, filled_cells: filled_cells)
end

def top_notch_rectangle
  filled_cells = []
  4.times do |row|
    6.times do |col|
      next if row.zero? && (col == 2 || col == 3)

      filled_cells << [row, col]
    end
  end
  grid_figure(rows: 4, cols: 6, filled_cells: filled_cells)
end

def bottom_right_extension
  grid_figure(
    rows: 4,
    cols: 4,
    filled_cells: [[0, 0], [0, 1], [1, 0], [1, 1], [2, 3], [3, 3]]
  )
end

def walkway_cross
  filled_cells = []
  5.times do |row|
    7.times do |col|
      next if row == 2 || col == 3

      filled_cells << [row, col]
    end
  end
  grid_figure(rows: 5, cols: 7, filled_cells: filled_cells)
end

def first_point(prompt)
  match = prompt.match(/\(([-]?\d+)\s*,\s*([-]?\d+)\)/)
  return nil unless match

  { 'x' => match[1].to_i, 'y' => match[2].to_i, 'label' => 'P' }
end

def coordinate_from_prompt(prompt)
  point = first_point(prompt) || { 'x' => 2, 'y' => 3, 'label' => 'P' }
  max_x = [point['x'].abs + 2, 6].max
  max_y = [point['y'].abs + 2, 6].max
  coordinate_figure(point: point, max_x: max_x, max_y: max_y, highlight_point: point)
end

def shape_from_prompt(prompt)
  return 'compass' if prompt.include?('面向') || prompt.include?('北方') || prompt.include?('南方')
  return 'hexagon' if prompt.include?('六邊形')
  return 'pentagon' if prompt.include?('五邊形')
  return 'parallelogram' if prompt.include?('平行四邊形')
  return 'trapezoid' if prompt.include?('梯形')
  return 'oval' if prompt.include?('像雞蛋一樣')
  return 'circle' if prompt.include?('圓') || prompt.include?('車輪')

  nil
end

def inferred_figure(question)
  prompt = question.fetch('prompt').fetch('zh-Hant', '')
  subtopic = question['subtopic']

  return coordinate_from_prompt(prompt) if %w[
    coordinate_geometry
    coordinate_distance
    reflection
    reflection_x_axis
    rotation
    translation
    half_turn
  ].include?(subtopic)

  return shape_figure('compass') if subtopic == 'position_direction'
  return border_square if subtopic == 'border_counting'
  return cross_shape if prompt.include?('十字形')
  return l_shape if prompt.include?('L 形')
  return missing_corner_square if prompt.include?('2×2') && prompt.include?('拿掉')
  return row_of_four if prompt.include?('1×4')
  return square_two_by_two if prompt.include?('2×2 的大正方形')
  return walkway_cross if prompt.include?('走道')
  return top_notch_rectangle if prompt.include?('缺口') || prompt.include?('往裡剪出')
  return bottom_right_extension if prompt.include?('右側緊接著另一個長方形')

  inferred_shape = shape_from_prompt(prompt)
  return shape_figure(inferred_shape) if inferred_shape

  none_figure
end

def helpful_shape_diagram?(question)
  figure = question['figure']
  return false unless figure && figure['kind'] == 'shape_diagram'

  shape = figure.dig('params', 'shape')
  labels = figure.dig('params', 'labels') || {}
  return true if labels.values.any? { |value| !value.to_s.strip.empty? }

  %w[compass circle oval pentagon hexagon trapezoid parallelogram].include?(shape)
end

def normalize_question(question)
  if question.dig('figure', 'kind') == 'none'
    return question.merge('figure' => inferred_figure(question))
  end

  return question if helpful_shape_diagram?(question)
  return question unless question.dig('figure', 'kind') == 'shape_diagram'

  question.merge('figure' => none_figure)
end

updated = []

GEOMETRY_FILES.each do |path|
  payload = JSON.parse(path.read)
  before = payload['questions'].map { |question| JSON.dump(question['figure']) }
  payload['questions'] = payload.fetch('questions').map { |question| normalize_question(question) }
  after = payload['questions'].map { |question| JSON.dump(question['figure']) }
  next if before == after

  path.write(JSON.pretty_generate(payload) + "\n")
  updated << path.basename.to_s
end

if updated.empty?
  puts 'No geometry figures needed backfill.'
else
  updated.each { |filename| puts filename }
end
