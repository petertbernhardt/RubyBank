require 'DatabaseHandler'
require 'AccountActions'

class Main
  puts "Please enter your name. "
  name = gets.chomp
  puts "Please enter your PIN. "
  pin = gets.chomp
  handler = DatabaseHandler.new("bank.db")
  query = "SELECT name, pin FROM users 
            WHERE name = '#{name}' AND pin = #{pin}"
  data = handler.execute(query)
  if data.size == 0
    puts "User not found. Would you like to make an account? Y/N "
    input = gets.chomp.downcase
    if input == "y"
      # make an account
    else
      puts "Have a nice day."
    end
  else
    account = AccountActions.new(name)
    puts "What do you want to do?"
    puts "(d)isplay balance, (w)ithdraw money, d(e)posit money, or (c)hange your pin"
    choice = gets.chomp.downcase[0]
    case choice
      when "d"
        account.display_balance
      when "w"
        puts "How much would you like to withdraw? "
        amount = gets.to_i
        account.withdraw(amount)
      when "e"
        puts "How much would you like to deposit? "
        amount = gets.to_i
        account.deposit(amount)
      when "c"
        puts "Change Pin"
    end
  end
end