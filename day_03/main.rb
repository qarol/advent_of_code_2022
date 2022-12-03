# frozen_string_literal: true

require "minitest/autorun"

class Rucksack
  CHARACTERS = [*('a'..'z'), *('A'..'Z')].freeze
  PRIORITIES = (1..CHARACTERS.size).freeze
  MAPPER = CHARACTERS.zip(PRIORITIES).to_h.freeze

  def initialize
    @compartments = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_item_to_compartment(compartment, *items)
    @compartments[compartment].concat(items)
  end

  def get_compartment_difference
    @compartments.values.reduce(:&).uniq
  end

  def get_compartment_difference_priorities
    get_compartment_difference.map { |item| MAPPER[item] }
  end
end

class TestRucksack < Minitest::Test
  def test_rucksack_1
    rucksack = Rucksack.new
    rucksack.add_item_to_compartment(:left,"v", "J", "r", "w", "p", "W", "t", "w", "J", "g", "W", "r")
    rucksack.add_item_to_compartment(:right, "h", "c", "s", "F", "M", "M", "f", "F", "F", "h", "F", "p")

    assert_equal ["p"], rucksack.get_compartment_difference
    assert_equal [16], rucksack.get_compartment_difference_priorities
  end

  def test_rucksack_2
    rucksack = Rucksack.new
    rucksack.add_item_to_compartment(:left, "j", "q", "H", "R", "N", "q", "R", "j", "q", "z", "j", "G", "D", "L", "G", "L")
    rucksack.add_item_to_compartment(:right, "r", "s", "F", "M", "f", "F", "Z", "S", "r", "L", "r", "F", "Z", "s", "S", "L")

    assert_equal ["L"], rucksack.get_compartment_difference
    assert_equal [38], rucksack.get_compartment_difference_priorities
  end

  def test_rucksack_3
    rucksack = Rucksack.new
    rucksack.add_item_to_compartment(:left, "P", "m", "m", "d", "z", "q", "P", "r", "V")
    rucksack.add_item_to_compartment(:right, "v", "P", "w", "w", "T", "W", "B", "w", "g")

    assert_equal ["P"], rucksack.get_compartment_difference
    assert_equal [42], rucksack.get_compartment_difference_priorities
  end
end


# Parse input (task 1)
ARGV.each do |filename|
  sum = 0

  File.foreach(filename).each do |line|
    rucksack = Rucksack.new
    chars = line.chomp.chars
    left, right = chars.each_slice((chars.size/2.0).round ).to_a

    rucksack.add_item_to_compartment(:left, *left)
    rucksack.add_item_to_compartment(:right, *right)

    sum += rucksack.get_compartment_difference_priorities.sum
  end

  puts "Sum: #{sum}"
end

# Parse input (task 2)
ARGV.each do |filename|
  sum = 0

  File.foreach(filename).each_slice(3) do |lines|
    rucksack = Rucksack.new

    lines.each_with_index do |line, i|
      chars = line.chomp.chars
      rucksack.add_item_to_compartment(i, *chars)
    end

    sum += rucksack.get_compartment_difference_priorities.sum
  end

  puts "Sum: #{sum}"
end
