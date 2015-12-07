system 'clear'

puts 'Welcome to the loan calculator!'
puts

puts 'How much will you borrow? (in dollars)'
principal = gets.chomp.to_f
puts

puts "What is the loan's APR? (in percent)"
apr = gets.chomp.to_f / 100
puts

puts "What is the loan's term? (in years)"
term = gets.chomp.to_f
puts

monthly_interest = apr / 12
months = term * 12

interest_ratio = (1 + monthly_interest)**months

monthly_payment = principal * monthly_interest * interest_ratio / \
                  (interest_ratio - 1)

puts monthly_payment
