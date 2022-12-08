# frozen_string_literal: true

require "minitest/autorun"

class FileExample
  attr_reader :name, :size

  def initialize(name:, size:)
    @name = name
    @size = size
  end
end

class Directory
  attr_reader :children, :name, :parent

  def initialize(name:, parent: nil)
    @name = name
    @parent = parent
    @children = []
  end

  def add_file(name:, size:)
    FileExample.new(name: name, size: size).tap do |file|
      @children << file
    end
  end

  def add_directory(name:)
    Directory.new(name: name, parent: self).tap do |dir|
      @children << dir
    end
  end

  def size
    @children.map(&:size).sum
  end

  def directories_size
    result = [[name, size]]
    @children.each do |child|
      if child.is_a?(Directory)
        child.directories_size.each do |path, s|
          result << [File.join(name, path), s]
        end
      end
    end
    result
  end

  def root
    parent ? parent.root : self
  end
end

class TestDirectory < Minitest::Test
  def setup
    @directory = Directory.new(name: "/")
  end

  def test_add_file
    @directory.add_file(name: "foo.txt", size: 1024)
    @directory.add_file(name: "bar.txt", size: 2048)

    assert_equal 2, @directory.children.size
  end

  def test_add_directory
    @directory.add_directory(name: "foo")
    @directory.add_directory(name: "bar")

    assert_equal 2, @directory.children.size
  end

  def test_size
    @directory.add_file(name: "foo.txt", size: 1024)
    @directory.add_file(name: "bar.txt", size: 2048)
    dir_1 = @directory.add_directory(name: "foo")
    dir_1.add_file(name: "baz.txt", size: 4096)
    dir_2 = dir_1.add_directory(name: "bar")
    dir_2.add_file(name: "qux.txt", size: 8192)

    assert_equal 15360, @directory.size
  end

  def test_parent
    @directory.add_file(name: "foo.txt", size: 1024)
    @directory.add_file(name: "bar.txt", size: 2048)
    dir_1 = @directory.add_directory(name: "foo")
    dir_1.add_file(name: "baz.txt", size: 4096)
    dir_2 = dir_1.add_directory(name: "bar")
    dir_2.add_file(name: "qux.txt", size: 8192)

    assert_equal @directory, dir_1.parent
    assert_equal dir_1, dir_2.parent
  end

  def test_directories_size
    dir_1 = @directory.add_directory(name: "a")
    dir_2 = dir_1.add_directory(name: "e")
    dir_2.add_file(name: "i", size: 584)
    dir_1.add_file(name: "f", size: 29116)
    dir_1.add_file(name: "g", size: 2557)
    dir_1.add_file(name: "h.lst", size: 62596)
    @directory.add_file(name: "b.txt", size: 14848514)
    @directory.add_file(name: "c.txt", size: 8504156)
    dir_1 = @directory.add_directory(name: "d")
    dir_1.add_file(name: "j", size: 4060174)
    dir_1.add_file(name: "d.log", size: 8033020)
    dir_1.add_file(name: "d.ext", size: 5626152)
    dir_1.add_file(name: "k", size: 7214296)

    assert_equal [["/", 48381165], ["/a", 94853], ["/a/e", 584], ["/d", 24933642]], @directory.directories_size
    assert_equal @directory, dir_1.root
  end
end

# Parse input (task 1)
ARGV.each do |filename|
  File.foreach(filename) do |line|
    case line.chomp
    when /^\$ cd (\/)$/
      @directory = Directory.new(name: $1)
    when /^\$ cd \.\.$/
      @directory = @directory.parent
    when /^\$ cd (\w.*)$/
      @directory = @directory.children.find { |child| child.name == $1 }
    when /^dir (.+)$/
      @directory.add_directory(name: $1)
    when /^(\d+) (.+)$/
      @directory.add_file(name: $2, size: $1.to_i)
    else
      # ignore
    end
  end

  puts "--- Task 1 ---"
  puts "#{filename} => #{@directory.root.directories_size.select{ |_, size| size < 100000 }.sum{ |_, size| size }}"
  puts "--- Task 2 ---"

  total_size = 70000000
  required_size = 30000000
  max_used = total_size - required_size
  root_size = @directory.root.size
  floor_size = root_size - max_used
  sorted_tree = @directory.root.directories_size.sort_by { |_, size| size }
  result = sorted_tree.detect { |_, size| size > floor_size }

  puts "Best option: #{result.inspect}"
end
