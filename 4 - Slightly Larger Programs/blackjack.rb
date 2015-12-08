# Blackjack program for Tealeaf

def clear_screen
  system "clear" or system "cls"
end

def ask_for_name
  puts "What's your name?"
  gets.chomp.capitalize
end

def greet_player(name)
  puts "Hello, #{name}. Welcome to Blackjack!"
end

def new_shoe(number_of_decks)
  suits = ["S", "H", "D", "C"]
  cards = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

  deck = cards.product(suits)

  shoe = []
  number_of_decks.times do
    shoe << deck
  end

  shoe.flatten(1).shuffle
end

def display_cards(cards)
  cards.each { |card| puts "#{card[0]} of #{card[1]}" }
end

def hand_value(hand)
  total = 0
  number_of_aces = 0

  values = hand.map { |card| card[0] }

  values.each do |value|
    case value
    when "A"
      total += 11
      number_of_aces += 1
    when "T", "J", "Q", "K"
      total += 10
    else
      total += value.to_i
    end
  end

  while total > 21 && number_of_aces > 0
    number_of_aces -= 1
    total -= 10
  end

  total
end

def display_hands(turn, dealer_hand, player_hand)
  dealer_total = hand_value(dealer_hand)
  player_total = hand_value(player_hand)

  clear_screen
  puts "The dealer has:"
  if turn == :player
    puts "??"
    display_cards(dealer_hand.drop(1))
  else
    display_cards(dealer_hand)
    puts "Total: #{dealer_total}"
  end
  puts "\n"
  puts "You have:"
  display_cards(player_hand)
  puts "Total: #{player_total}"
  puts "\n"
end

def heighten_suspense
  2.times do
    print "."
    sleep 0.3
  end
  print ". "
  sleep 0.5
end

name = ask_for_name
greet_player(name)
sleep 1

loop do
  # Initialize variables
  turn = :player
  shoe = new_shoe(1)
  game_over = false
  blackjack = false

  player_hand = []
  dealer_hand = []

  2.times do
    player_hand << shoe.pop
    dealer_hand << shoe.pop
  end

  dealer_total = hand_value(dealer_hand)
  player_total = hand_value(player_hand)

  if player_total == 21
    game_over = true
    blackjack = true
  end

  until game_over == true
    display_hands(turn, dealer_hand, player_hand)

    if turn == :player
      choice = ""
      loop do
        puts "What would you like to do?"
        puts "1) Hit"
        puts "2) Stay"
        choice = gets.chomp
        if choice == "1" || choice == "2"
          break
        end
      end

      if choice == "1"
        player_hand << shoe.pop
      else
        turn = :dealer
      end
    else # Dealer's turn
      unless dealer_total >= 17
        puts "Dealer hits"
        dealer_hand << shoe.pop
      end
    end

    heighten_suspense

    dealer_total = hand_value(dealer_hand)
    player_total = hand_value(player_hand)

    if player_total >= 21
      turn = :dealer
    end

    if player_total > 21 || turn == :dealer && dealer_total >= 17
      game_over = true
    end
  end

  display_hands(:dealer, dealer_hand, player_hand)

  print "Game over! "
  heighten_suspense

  if player_total > 21
    puts "You are bust!"
  elsif dealer_total > 21
    puts "Dealer is bust. You win!"
  elsif player_total == dealer_total
    puts "It's a tie!"
  elsif blackjack == true
    puts "You got Blackjack!"
  elsif player_total > dealer_total
    puts "You won, with #{player_total} beating #{dealer_total}!"
  else
    puts "You lost. Dealer's #{dealer_total} beat your #{player_total}."
  end

  puts "Want to play again? (y/n)"
  response = gets.chomp.downcase
  unless response == "y"
    break
  end
end
