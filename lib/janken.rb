class Player
  attr_accessor :score

  def initialize
    @score = 0
  end

  def throw
    %i[グー チョキ パー].sample
  end
end

class Janken
  HANDS = { グー: 0, チョキ: 1, パー: 2 }

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play
    hand1 = @player1.throw
    hand2 = @player2.throw
    # じゃんけんの勝ち負けを判断
    result = judge(hand1, hand2)
    # スコア計算を行う
    if result == "勝ち"
      @player1.score += 10
    elsif result == "負け"
      @player2.score += 10
    end
    # フォーマットを整える
    format_result(result, hand1, hand2, @player1.score, @player2.score)
  end

  def judge(hand1, hand2)
    case HANDS[hand1] - HANDS[hand2] % 3
    when 0
      "あいこ"
    when 1
      "負け"
    when 2
      "勝ち"
    end
  end

  def format_result(result, hand1, hand2, score1, score2)
    string = ""
    string << "(プレイヤー1) #{hand1} (プレイヤー2) #{hand2}\n"
    string << result << "！\n" if result == "あいこ"
    string << "プレイヤー1: #{score1}点\n"
    string << "プレイヤー2: #{score2}点"
  end
end

class Game
  def initialize(count)
    @player1 = Player.new
    @player2 = Player.new
    @count = count
  end

  def play
    result = ""
    @count.times do |n|
      janken = Janken.new(@player1, @player2)
      result << "<#{n + 1}回目>\n"
      result << "#{janken.play}\n"
    end
    result << judge
  end

  def judge
    message = "<最終結果>"
    message << if @player1.score > @player2.score
      "プレイヤー1の勝ち！！！"
    elsif @player1.score < @player2.score
      "プレイヤー2の勝ち！！！"
    else
      "引き分け！"
    end
  end
end

__END__
$ ruby janken.rb
(プレイヤー1) グー (プレイヤー2) チョキ
プレイヤー1: 10点
プレイヤー2: 0点

スコアはプレイヤーが管理しておく
じゃんけんの回数をどこで管理する？ → Gameクラス作って管理
game = Game.new
game.play
