class Hand
  def select
    ['グー', 'チョキ', 'パー'].sample
  end
end

class Game
  def initialize
    @player1 = Hand.new
    @player2 = Hand.new
    @score1 = 0
    @score2 = 0
  end

  def judge
    player1_hand = @player1.select
    player2_hand = @player2.select
    result = if player1_hand == 'グー' && player2_hand == 'チョキ' || player1_hand == 'チョキ' && player2_hand == 'パー'|| player1_hand == 'パー' && player2_hand == 'グー'
      '勝ち'
    elsif player1_hand == 'グー' && player2_hand == 'パー'|| player1_hand == 'チョキ' && player2_hand == 'グー'|| player1_hand == 'パー' && player2_hand == 'チョキ'
      '負け'
    else 
      'あいこ'
    end
    [player1_hand, player2_hand, result]
  end

  def play
    results = judge
    header = "(プレーヤー1)#{results[0]} (プレイヤー2)#{results[1]}\n"
    body = if results[2] == '勝ち'
        @score1 += 10
        "プレイヤー1: #{@score1}点\n" + "プレイヤー2: #{@score2}点"
    elsif results[2] == '負け'
        @score2 += 10
        "プレイヤー1: #{@score1}点\n" + "プレイヤー2: #{@score2}点"
    else
        "あいこ!\n" + "プレイヤー1: #{@score1}点\n" + "プレイヤー2: #{@score2}点"
    end
    header + body
  end

  def match
    5.times do |i|
      puts "<#{i+1}回目>"
      puts play
      puts if @score1 > @score2
      'プレイヤー1の勝ち!!!'
      elsif @score1 < @score2
        'プレイヤー2の勝ち!!!'
        else
            'あいこ'
        end
    end
  end
end


game = Game.new
game.match
