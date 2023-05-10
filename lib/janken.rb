class Player
  attr_reader :name
  attr_accessor :score, :janken_count, :win_count, :draw_count_in_one_game, :bonus_once

  def initialize(name)
    @score = 0
    @name = name
    @janken_count = 0
    @win_count = 0
    @draw_count_in_one_game = 0
    @lose_hand = ''
    @bonus_once = false
  end

  def throw
    %i[グー チョキ パー].sample
  end

  def increment_janken_count!
    @janken_count += 1
  end

  def calculate_bonus(hand)
    return if @bonus_once

    if @lose_hand.empty?
      @lose_hand += hand.to_s
    elsif @lose_hand == hand && !@bonus_once
      @score += 10
      @bonus_once = true
    else
      @lose_hand = ''
    end
  end

  def calculate_score(result, hand)
    # 勝ち
    if result == 1
      @score += 10
    # 負け
    elsif result == -1
      calculate_bonus(hand)
    end
  end
end

class Janken
  HANDS = { グー: 0, チョキ: 1, パー: 2 }

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @hands = [@player1.throw, @player2.throw]
  end

  def play
    # じゃんけんの勝ち負けを判断
    result = judge

    if result == 0
      increment_draw_count
    else
      # 1と-1が反転することで、勝ちと負けを表してる
      @player1.calculate_score(result, @hands[0])
      @player2.calculate_score(-result, @hands[1])
      reset_draw_count
    end
    # フォーマットを整える
    format_result(result)
  end

  def judge
    case (HANDS[@hands[0]] - HANDS[@hands[1]]) % 3
    when 0
      0
    when 1
      -1
    when 2
      1
    end
  end

  def draw?
    judge == 0
  end

  def format_result(result)
    string = ""
    string << "(#{@player1.name}) #{@hands[0]} (#{@player2.name}) #{@hands[1]}\n"
    string << "あいこ" << "！\n" if result == 0
    string << "#{@player1.name}: #{@player1.score}点\n"
    string << "#{@player2.name}: #{@player2.score}点"
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
    @draw_count_in_a_row = 0
  end

  def play
    result = ""

    @count.times do |n|
      janken = Janken.new(*@players)
      result << "<#{n + 1}回目>\n"
      result << "#{janken.play}\n"
      @players.each(&:increment_janken_count!)

      calc_draw_in_a_row(janken)

      if three_times_draw_in_a_row?
        result << "3回連続あいこになったのでじゃんけんを中止します。\n"
        result << '<最終結果> 引き分け！！！'
        @players.each { |player| player.bonus_once = false }

        return result
      end
    end

    result << result_announcement
    increment_win_count!
    @players.each { |player| player.bonus_once = false }

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

  def calc_draw_in_a_row(janken)
    janken.draw? ? @draw_count_in_a_row += 1 : @draw_count_in_a_row = 0
  end

  def three_times_draw_in_a_row?
    @draw_count_in_a_row >= 3
  end
end

players = [Player.new('taro'), Player.new('hanako')]

puts Game.new(5, players).play

__END__
残り
- [x] 次回3回連続あいこの挙動のテストから
- [ ] (7)の実装
