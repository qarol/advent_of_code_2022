# frozen_string_literal: true

require "minitest/autorun"
require "set"

class Tree
  include Comparable

  attr_reader :x, :y, :height

  def initialize(x:, y:, height:)
    @x = x
    @y = y
    @height = height
  end

  def <=>(other)
    [x, y] <=> [other.x, other.y]
  end
end

class Forest
  attr_reader :trees, :forest

  def initialize
    @forest = []
  end

  def add_trees(*heights)
    @forest << heights.map.with_index { |height, i| Tree.new(y: i, x: @forest.size, height: height) }
  end

  def visible_trees
    @visible_trees = Set.new

    4.times do |i|
      @forest.each do |trees|
        max_height = -1
        trees.each do |tree|
          next if tree.height <= max_height

          @visible_trees << tree
          max_height = tree.height
        end
      end
      @forest = @forest.transpose.map(&:reverse)
    end

    @visible_trees
  end
end

class TestForest < Minitest::Test
  def setup
    @forest = Forest.new
  end

  def test_add_trees
    @forest.add_trees(3,0,3,7,3)
    @forest.add_trees(2,5,5,1,2)
    @forest.add_trees(6,5,3,3,2)
    @forest.add_trees(3,3,5,4,9)
    @forest.add_trees(3,5,3,9,0)

    assert_equal 21, @forest.visible_trees.size
  end
end



# Parse input (task 1)
ARGV.each do |filename|
  forest = Forest.new

  File.foreach(filename) do |line|
    forest.add_trees(*line.strip.chars.map(&:to_i))
  end

  puts "--- Task 1 ---"
  puts "File: #{filename}: #{forest.visible_trees.size}"
end
