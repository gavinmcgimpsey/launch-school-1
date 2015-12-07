# 1. Ask player for input and generate computer input
# 2. Determine winner
# 3. Display winner
# 4. Ask to play again

CHOICES = {'r' => 'Rock', 'p' => 'Paper', 's' => 'Scissors'}

def who_wins?(player_choice, computer_choice)
  if player_choice == computer_choice
    return nil
  elsif (player_choice == 'r' && computer_choice == 's') ||
       (player_choice == 'p' && computer_choice == 'r') ||
       (player_choice == 's' && computer_choice == 'p')
      result = {name: "Player", win_choice: CHOICES[player_choice],
         lose_choice: CHOICES[computer_choice]}
  else
      result = {name: "Computer", win_choice: CHOICES[computer_choice],
        lose_choice: CHOICES[player_choice]}
  end
  return result
end

loop do

  # Ask player for input and generate computer input
  loop do
    print "Choose one: (p)aper, (r)ock, (s)cissors: "
    player_choice = gets.chomp.downcase
    break if CHOICES.keys.include?(player_choice)
  end

  computer_choice = CHOICES.keys.sample

  # Determine winner
  winner = who_wins?(player_choice, computer_choice)

  # Display winner
  if winner == nil
    puts "Tie!"
  else
    puts "#{winner[:win_choice]} beats #{winner[:lose_choice]}."
    puts "#{winner[:name]} wins!"
  end

  # Ask to play again
  puts "Want to play again? (y/n)"
  play_again = gets.chomp.downcase
  unless play_again == 'y'
    break
  end
end
