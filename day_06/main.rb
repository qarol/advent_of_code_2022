# frozen_string_literal: true

require "minitest/autorun"

class Device
  def find_marker_index(str, length: 4)
    index = str.chars.each_cons(length).find_index do |arr|
      arr.uniq.size == length
    end

    index + length
  end
end

class TestDevice < Minitest::Test
  def setup
    @device = Device.new
  end

  def test_find_marker_index_1
    assert_equal 5, @device.find_marker_index("bvwbjplbgvbhsrlpgdmjqwftvncz")
  end

  def test_find_marker_index_2
    assert_equal 6, @device.find_marker_index("nppdvjthqldpwncqszvftbrmjlhg")
  end

  def test_find_marker_index_3
    assert_equal 10, @device.find_marker_index("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
  end

  def test_find_marker_index_4
    assert_equal 11, @device.find_marker_index("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  end
end


# Parse input (task 1)
ARGV.each do |filename|
  device = Device.new
  File.foreach(filename) do |line|
    marker = device.find_marker_index(line.chomp)
    message = device.find_marker_index(line.chomp, length: 14)

    puts "marker: #{marker}, message: #{message}"
  end
end
