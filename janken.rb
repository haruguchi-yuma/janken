class Hand
  def throw
    %w[gu choki pa].sample
  end
end

def judge(hand1, hand2)
  if hand1 == hand2 
    'aiko'
  elsif hand1 == 'gu'    && hand2 == 'choki' ||
        hand1 == 'choki' && hand2 == 'pa' ||
        hand1 == 'pa'    && hand2 == 'gu'
    'kachi'    
  else
    'make'
  end
end

player1_score = 0
player2_score = 0

# NOTE: ループの書き方
# for n in 1..5
# 1.upto(5) do |n|
# 5.times do |n| n + 1
# while count <= 5; ...; end

1.upto(5) do |n|
  puts "#{n}kaime"

  player1_hand = Hand.new.throw
  player2_hand = Hand.new.throw
  puts "(player1) #{player1_hand} (player2) #{player2_hand}"

  result = judge(player1_hand, player2_hand)
  case result
  when 'kachi'
    player1_score += 10
  when 'make'
    player2_score += 10
  else
    puts 'aiko!'
  end

  puts "player1: #{player1_score}points"
  puts "player2: #{player2_score}points"
end

if player1_score == player2_score
  puts "<final result>draw!!!"
elsif player1_score > player2_score
  puts "<final result>player1 wins!!!"
else
  puts "<final result>player2 wins!!!"
end

#puts player1_hand
#puts player2_hand

require 'minitest/autorun'

class JunkenTest < Minitest::Test
  def test_janken_kachi
    assert_equal 'kachi', judge('gu',    'choki')
    assert_equal 'kachi', judge('choki', 'pa')
    assert_equal 'kachi', judge('pa',    'gu')
  end

  def test_janken_aiko
    assert_equal 'aiko', judge('gu',    'gu')
    assert_equal 'aiko', judge('choki', 'choki')
    assert_equal 'aiko', judge('pa',    'pa')
  end

  def test_janken_make
    assert_equal 'make', judge('gu',    'pa')
    assert_equal 'make', judge('pa',    'choki')
    assert_equal 'make', judge('choki', 'gu')
  end
end
