# frozen_string_literal: true

require "minitest/autorun"

class MostCalories
  def initialize
    @most_calories = 0
    @current_calories = 0
  end

  def add_calories(calories)
    @current_calories += calories
  end

  def next_elf
    @most_calories = [@most_calories, @current_calories].max
    @current_calories = 0
  end

  def most_calories
    @most_calories
  end
end

class TestMostCalories < Minitest::Test
  def setup
    @calculator = MostCalories.new
  end

  def test_usage
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
    @calculator.add_calories(1000)
    @calculator.next_elf

    assert_equal 24000, @calculator.most_calories
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

  puts "Most calories: #{calculator.most_calories}"
end
