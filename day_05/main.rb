# frozen_string_literal: true

require "minitest/autorun"

class Cargo
  attr_reader :stacks

  def initialize(*stacks)
    @stacks = stacks
  end

  def move(from:, to:, count: 1)
    cranes = @stacks[from-1].pop(count)
    @stacks[to-1].concat(cranes)
  end

  def top_cranes
    @stacks.map(&:last)
  end
end

class TestCargo < Minitest::Test
  def setup
    @cargo = Cargo.new(
      ["Z", "N"],
      ["M", "C", "D"],
      ["P"]
    )
  end

  def test_move_1
    1.times { @cargo.move(from: 2, to: 1) }
    3.times { @cargo.move(from: 1, to: 3) }
    2.times { @cargo.move(from: 2, to: 1) }
    1.times { @cargo.move(from: 1, to: 2) }

    assert_equal [["C"], ["M"], ["P", "D", "N", "Z"]], @cargo.stacks
    assert_equal ["C", "M", "Z"], @cargo.top_cranes
  end

  def test_move_2
    @cargo.move(count: 1, from: 2, to: 1)
    @cargo.move(count: 3, from: 1, to: 3)
    @cargo.move(count: 2, from: 2, to: 1)
    @cargo.move(count: 1, from: 1, to: 2)

    assert_equal [["M"], ["C"], ["P", "Z", "N", "D"]], @cargo.stacks
    assert_equal ["M", "C", "D"], @cargo.top_cranes
  end
end

# Parse input (task 1)
ARGV.each do |filename|
  cargo = Cargo.new(
    ["R", "P", "C", "D", "B", "G"],
    ["H", "V", "G"],
    ["N", "S", "Q", "D", "J", "P", "M"],
    ["P", "S", "L", "G", "D", "C", "N", "M"],
    ["J", "B", "N", "C", "P", "F", "L", "S"],
    ["Q", "B", "D", "Z", "V", "G", "T", "S"],
    ["B", "Z", "M", "H", "F", "T", "Q"],
    ["C", "M", "D", "B", "F"],
    ["F", "C", "Q", "G"]
  )
  File.foreach(filename) do |line|
    matches = line.chomp.match(/^move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)$/)
    matches[:count].to_i.times { cargo.move(from: matches[:from].to_i, to: matches[:to].to_i) }
  end

  puts "top_cranes: #{cargo.top_cranes.join}"
end


# Parse input (task 2)
ARGV.each do |filename|
  cargo = Cargo.new(
    ["R", "P", "C", "D", "B", "G"],
    ["H", "V", "G"],
    ["N", "S", "Q", "D", "J", "P", "M"],
    ["P", "S", "L", "G", "D", "C", "N", "M"],
    ["J", "B", "N", "C", "P", "F", "L", "S"],
    ["Q", "B", "D", "Z", "V", "G", "T", "S"],
    ["B", "Z", "M", "H", "F", "T", "Q"],
    ["C", "M", "D", "B", "F"],
    ["F", "C", "Q", "G"]
  )
  File.foreach(filename) do |line|
    matches = line.chomp.match(/^move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)$/)
    cargo.move(count: matches[:count].to_i, from: matches[:from].to_i, to: matches[:to].to_i)
  end

  puts "top_cranes: #{cargo.top_cranes.join}"
end
