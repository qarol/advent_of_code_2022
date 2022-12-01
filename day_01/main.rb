# frozen_string_literal: true

require "minitest/autorun"

class MostCalories
  def initialize
    @calories = []
    @current_calories = 0
  end

  def add_calories(calories)
    @current_calories += calories
  end

  def next_elf
    @calories << @current_calories
    @current_calories = 0
  end

  def most_calories(limit)
    @calories.sort.reverse.take(limit).sum
  end
end

class TestMostCalories < Minitest::Test
  def setup
    @calculator = MostCalories.new
    @calculator.add_calories(1000)
    @calculator.add_calories(2000)
    @calculator.add_calories(3000)
    @calculator.next_elf
    @calculator.add_calories(4000)
    @calculator.next_elf
    @calculator.add_calories(5000)
    @calculator.add_calories(6000)
    @calculator.next_elf
    @calculator.add_calories(7000)
    @calculator.add_calories(8000)
    @calculator.add_calories(9000)
    @calculator.next_elf
    @calculator.add_calories(10000)
    @calculator.next_elf
  end

  def test_top_1
    assert_equal 24000, @calculator.most_calories(1)
  end

  def test_top_3
    assert_equal 45000, @calculator.most_calories(3)
  end
end

# Parse input
ARGV.each do |filename|
  calculator = MostCalories.new

  File.foreach(filename).each do |line|
    if line.chomp.empty?
      calculator.next_elf
    else
      calculator.add_calories(line.to_i)
    end
  end

  calculator.next_elf

  puts "Top 1 -> #{calculator.most_calories(1)}"
  puts "Top 3 -> #{calculator.most_calories(3)}"
end
