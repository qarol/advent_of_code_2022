# frozen_string_literal: true

require "minitest/autorun"

class Elf
  attr_reader :sections

  def initialize(*sections)
    @sections = sections
  end

  def overlaps?(other_elf)
    @sections & other_elf.sections != []
  end

  def full_overlaps?(other_elf)
    @sections - other_elf.sections == [] ||
      other_elf.sections - @sections == []
  end
end

class TestElf < Minitest::Test
  def test_elf_overlaps_1
    @elf_a = Elf.new(*2..6)
    @elf_b = Elf.new(*6..8)
    assert_equal false, @elf_a.full_overlaps?(@elf_b)
    assert_equal true, @elf_a.overlaps?(@elf_b)
  end

  def test_elf_overlaps_2
    @elf_a = Elf.new(*6..6)
    @elf_b = Elf.new(*4..6)
    assert_equal true, @elf_a.full_overlaps?(@elf_b)
    assert_equal true, @elf_a.overlaps?(@elf_b)
  end

  def test_elf_overlaps_3
    @elf_a = Elf.new(*1..3)
    @elf_b = Elf.new(*4..6)
    assert_equal false, @elf_a.full_overlaps?(@elf_b)
    assert_equal false, @elf_a.overlaps?(@elf_b)
  end
end


# Parse input (task 1)
ARGV.each do |filename|
  full_overlaps = 0
  overlaps = 0
  File.foreach(filename).each do |line|
    first, second = line.chomp.split(",").map { |sections| sections.split("-").map(&:to_i) }.map { |a,b| a..b }
    elf_a = Elf.new(*first)
    elf_b = Elf.new(*second)
    full_overlaps += 1 if elf_a.full_overlaps?(elf_b)
    overlaps += 1 if elf_a.overlaps?(elf_b)
  end

  puts "Full overlaps: #{full_overlaps}, overlaps: #{overlaps}"
end
