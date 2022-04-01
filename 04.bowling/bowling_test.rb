# frozen_string_literal: true

require 'minitest/autorun'
require_relative './bowling'

class ShowBowlingTotalScoreTest < Minitest::Test
  def test_show_bowling_total_score
    assert_equal 139, show_bowling_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 164, show_bowling_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 107, show_bowling_total_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 134, show_bowling_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 144, show_bowling_total_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8')
    assert_equal 300, show_bowling_total_score('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
