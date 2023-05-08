class Player
  attr_reader :name
  attr_accessor :score, :janken_count, :win_count, :draw_count_in_one_game

  def initialize(name)
    @score = 0
    @name = name
    @janken_count = 0
    @win_count = 0
    @draw_count_in_one_game = 0
  end

  def throw
    # %i[グー チョキ パー].sample
    :グー
  end

  def increment_janken_count!
    @janken_count += 1
  end

  def three_times_draw_in_a_row?
    @draw_count_in_one_game >= 3
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
      reset_draw_count
    elsif result == "負け"
      @player2.score += 10
      reset_draw_count
    else
      increment_draw_count
    end
    # フォーマットを整える
    format_result(result, hand1, hand2, @player1, @player2)
  end

  def judge(hand1, hand2)
    case (HANDS[hand1] - HANDS[hand2]) % 3
    when 0
      "あいこ"
    when 1
      "負け"
    when 2
      "勝ち"
    end
  end

  def format_result(result, hand1, hand2, player1, player2)
    string = ""
    string << "(#{player1.name}) #{hand1} (#{player2.name}) #{hand2}\n"
    string << result << "！\n" if result == "あいこ"
    string << "#{player1.name}: #{player1.score}点\n"
    string << "#{player2.name}: #{player2.score}点"
  end

  def increment_draw_count
    @player1.draw_count_in_one_game += 1
    @player2.draw_count_in_one_game += 1
  end

  def reset_draw_count
    @player1.draw_count_in_one_game = 0
    @player2.draw_count_in_one_game = 0
  end
end

class Game
  def initialize(count, players)
    @players = players
    @count = count
  end

  def play
    result = ""
    @count.times do |n|
      janken = Janken.new(*@players)
      result << "<#{n + 1}回目>\n"
      result << "#{janken.play}\n"
      @players.each(&:increment_janken_count!)
      if @players.any?(&:three_times_draw_in_a_row?)
        result << "3回連続あいこになったのでじゃんけんを中止します。\n"
        result << '<最終結果> 引き分け！！！'
        return result
      end
    end

    result << result_announcement
    increment_win_count!

    result
  end

  def result_announcement
    message = "<最終結果>"
    message +=
      case judge
      when 1
        "#{@players[0].name}の勝ち！！！"
      when -1
        "#{@players[1].name}の勝ち！！！"
      else
        "引き分け！"
      end
  end

  def judge
    @players[0].score <=> @players[1].score
  end

  def increment_win_count!
    if judge == 1
      @players[0].win_count += 1
    elsif judge == -1
      @players[1].win_count += 1
    end
  end
end

players = [Player.new('taro'), Player.new('hanako')]
players => [a, b]

puts Game.new(5, players).play

__END__
残り
- 次回3回連続あいこの挙動のテストから
- (7)の実装
