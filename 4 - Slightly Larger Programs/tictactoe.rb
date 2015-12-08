# Tic Tac Toe game
# Exercise for Tealeaf course 1
require 'pry'

COMPUTER_SYMBOL = "o"
PLAYER_SYMBOL = "x"

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = " " }
  board
end

# Initialize visual key to help player pick a square
def key_board
  key = {}
  (1..9).each { |num| key[num] = num }
  key
end

def clear_screen
  system "clear" or system "cls"
end

def draw_board(board)
  puts " #{board[1]} | #{board[2]} | #{board[3]} "
  puts "---|---|---"
  puts " #{board[4]} | #{board[5]} | #{board[6]} "
  puts "---|---|---"
  puts " #{board[7]} | #{board[8]} | #{board[9]} "
end

def ask_player_for_square
  choice = nil
  until (1..9).include?(choice)
    puts "Pick a square:"

    draw_board(key_board)
    choice = gets.chomp.to_i
  end
  choice
end

def computer_square(board)
  choice = nil

  proactive_plays = two_in_a_row?(board)

  winning_play = proactive_plays.assoc(COMPUTER_SYMBOL)

  if winning_play
    choice = winning_play[1]
  elsif proactive_plays[0]
    choice = proactive_plays[0][1]
  elsif valid_play?(board, 5)
    choice = 5
  else
    until valid_play?(board, choice)
      choice = (1..9).to_a.sample
    end
  end
  choice
end

def valid_play?(board, square)
  if square && board[square] == " "
    return true
  else
    return false
  end
end

def two_in_a_row?(board)
  fill_following = [[1, 2], [4, 5], [7, 8],  # Horizontals
                    [1, 4], [2, 5], [3, 6],  # Verticals
                    [1, 5], [3, 5]]          # Diagonals

  fill_prior = [[2, 3], [5, 6], [8, 9], # Horizontals
                [4, 7], [5, 8], [6, 9], # Verticals
                [5, 7], [5, 9]]         # Diagonals

  fill_middle = [[1, 3], [4, 6], [7, 9], # Horizontals
                 [1, 7], [2, 8], [3, 9], # Verticals
                 [1, 9], [3, 7]] # Diagonals

  checks = fill_following + fill_prior + fill_middle

  threatened_squares = []

  checks.each do |squares|
    contents = [board[squares[0]], board[squares[1]]].uniq
    next unless contents.length == 1 && contents[0] != ' '

    distance = squares[1] - squares[0]
    next_square = if fill_following.include?(squares)
                    squares[1] + distance
                  elsif fill_prior.include?(squares)
                    squares[0] - distance
                  elsif fill_middle.include?(squares)
                    (squares[0] + squares[1]) / 2
                  end

    if valid_play?(board, next_square)
      threatening_player = contents[0]
      threatened_squares << [threatening_player, next_square]
    end

  end

  threatened_squares
end

def game_over?(board)
  win_possibilities = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # Horizontals
                       [1, 4, 7], [2, 5, 8], [3, 6, 9], # Verticals
                       [1, 5, 9], [3, 5, 7]] # Diagonals

  win_possibilities.each do |squares|
    contents = [board[squares[0]], board[squares[1]], board[squares[2]]].uniq
    if contents.length == 1 && contents[0] != ' '
      return board[squares[0]]
    end
  end
  if board.values.include?(" ") == false # Fall through if no winner
    return "tie"
  end
  false # Fall through if no winner and no tie
end

wins = { PLAYER_SYMBOL => 0, COMPUTER_SYMBOL => 0 }
loop do
  board = initialize_board
  turns = 0

  clear_screen
  puts "Welcome to Tic Tac Toe! You are #{PLAYER_SYMBOL}."
  draw_board(board)

  loop do
    if turns.even? # Player turn
      player_choice = nil
      until valid_play?(board, player_choice)
        player_choice = ask_player_for_square
      end
      board[player_choice] = PLAYER_SYMBOL

    else # Computer turn
      computer_choice = computer_square(board)
      board[computer_choice] = COMPUTER_SYMBOL
    end

    clear_screen
    draw_board(board)
    turns += 1

    break if game_over?(board)
  end

  # Display Result
  winner = game_over?(board)
  if winner != "tie"
    puts "The winner is #{winner}!"
    wins[winner] += 1
  else
    puts "Tie game!"
  end

  # Play again?
  break if wins.values.include?(5)

  puts "Want to play again? (y/n)"
  play_again = gets.chomp.downcase
  break unless play_again == 'y'
end

puts "Game over!"
puts "You won #{wins[PLAYER_SYMBOL]} game#{'s' if wins[PLAYER_SYMBOL] > 1 || wins[PLAYER_SYMBOL] == 0}."
puts "Computer won #{wins[COMPUTER_SYMBOL]} game#{'s' if wins[COMPUTER_SYMBOL] > 1 || wins[COMPUTER_SYMBOL] == 0}."
