# frozen_string_literal: true

require "minitest/autorun"

class RockPaperScissorsGame
  SELECTION_POINTS = { rock: 1, paper: 2, scissors: 3 }.freeze
  RESULT_POINTS = { lost: 0, draw: 3, win: 6 }.freeze

  def initialize
    @player_a_points = 0
    @player_b_points = 0
  end

  def play(player_a, player_b)
    @player_a_points += get_selection_points(player_a)
    @player_b_points += get_selection_points(player_b)

    points_for_a, points_for_b = get_game_points(player_a, player_b)
    @player_a_points += points_for_a
    @player_b_points += points_for_b
  end

  def play_unknown(player_a, expected_result)
    case [player_a, expected_result]
    when [:rock, :win], [:paper, :draw], [:scissors, :lost]
      play(player_a, :paper)
    when [:rock, :draw], [:paper, :lost], [:scissors, :win]
      play(player_a, :rock)
    when [:rock, :lost], [:paper, :win], [:scissors, :draw]
      play(player_a, :scissors)
    end
  end

  def points
    [@player_a_points, @player_b_points]
  end

  private

  def get_selection_points(player)
    SELECTION_POINTS.fetch(player, 0)
  end

  def get_game_points(*selections)
    case selections
    when [:rock, :paper], [:paper, :scissors], [:scissors, :rock]
      [RESULT_POINTS[:lost], RESULT_POINTS[:win]]
    when [:paper, :rock], [:scissors, :paper], [:rock, :scissors]
      [RESULT_POINTS[:win], RESULT_POINTS[:lost]]
    when [:paper, :paper], [:rock, :rock], [:scissors, :scissors]
      [RESULT_POINTS[:draw], RESULT_POINTS[:draw]]
    end
  end
end

class TestRockPaperScissorsGame < Minitest::Test
  def setup
    @game = RockPaperScissorsGame.new
  end

  def test_rock_paper
    @game.play(:rock, :paper)
    assert_equal [1, 8], @game.points
  end

  def test_paper_rock
    @game.play(:paper, :rock)
    assert_equal [8, 1], @game.points
  end

  def test_rock_scissors
    @game.play(:rock, :scissors)
    assert_equal [7, 3], @game.points
  end

  def test_scissors_rock
    @game.play(:scissors, :rock)
    assert_equal [3, 7], @game.points
  end

  def test_paper_scissors
    @game.play(:paper, :scissors)
    assert_equal [2, 9], @game.points
  end

  def test_scissors_paper
    @game.play(:scissors, :paper)
    assert_equal [9, 2], @game.points
  end

  def test_scissors_scissors
    @game.play(:scissors, :scissors)
    assert_equal [6, 6], @game.points
  end

  def test_rock_rock
    @game.play(:rock, :rock)
    assert_equal [4, 4], @game.points
  end

  def test_paper_paper
    @game.play(:paper, :paper)
    assert_equal [5, 5], @game.points
  end

  def test_input
    @game.play(:rock, :paper)
    @game.play(:paper, :rock)
    @game.play(:scissors, :scissors)
    assert_equal [15, 15], @game.points
  end
end

# Parse input
ARGV.each do |filename|
  game_1 = RockPaperScissorsGame.new
  game_2 = RockPaperScissorsGame.new

  mapper_1 = { "A" => :rock, "B" => :paper, "C" => :scissors, "X" => :rock, "Y" => :paper, "Z" => :scissors  }
  mapper_2 = { "A" => :rock, "B" => :paper, "C" => :scissors, "X" => :lost, "Y" => :draw, "Z" => :win  }

  File.foreach(filename).each do |line|
    left, right = line.chomp.split(" ")

    game_1.play(mapper_1[left], mapper_1[right])
    game_2.play_unknown(mapper_2[left], mapper_2[right])
  end

  puts "Game 1: -> #{game_1.points}"
  puts "Game 2: -> #{game_2.points}"
end
