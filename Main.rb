require 'DatabaseHandler'
require 'AccountActions'

class Main
  
  def again?(account)
    puts "Do you want to do something else? Y/N "
    choice = gets.chomp.downcase[0]
    if choice == "y"
      prompt(account)
    elsif choice == "n"
      puts "Have a nice day."
    else
      puts "Invalid input."
      again?(account)
    end
  end
  
  def prompt(account)
    puts "What do you want to do?"
    puts "display (b)alance, (w)ithdraw money, (d)eposit money, (c)hange your pin, or (t)ransfer money to another person"
    choice = gets.chomp.downcase[0]
    if choice == "b"
        account.display_balance
        again?(account)
    elsif choice == "w"
        puts "How much would you like to withdraw? "
        amount = gets.to_i
        account.withdraw(amount)
        again?(account)
    elsif choice == "e"
        puts "How much would you like to deposit? "
        amount = gets.to_i
        account.deposit(amount)
        again?(account)
    elsif choice == "c"
        puts "Please enter an integer to be your new PIN. "
        newPin = gets.to_i
        account.changePin(newPin)
        again?(account)
    elsif choice == "t"
        puts "What is the name of the person you'd like to give money to? "
        person = gets.chomp.downcase.capitalize
        account.transfer(person)
        again?(account)
    end
  end
  
  def run
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
        input = gets.chomp.downcase[0]
        if input == "y"
          # make an account
          puts "How much do you want to have in your account? "
          balance = gets.to_i
          puts "What do you want your PIN to be? "
          pin = gets.to_i
          account = AccountActions.new(name)
          account.setBal(balance)
          account.setPin(pin)
          handler.execute("INSERT INTO users (name, pin) VALUES ('#{name}', #{pin});")
          id = handler.execute("SELECT userId from users WHERE name = '#{name}';")[0][0]
          handler.execute("INSERT INTO accounts (balance, userId) VALUES (#{balance}, #{id});")
          prompt(account)
        elsif input == "n"
          puts "Have a nice day."
        else
          puts "Invalid input."
        end
      else
        account = AccountActions.new(name)
        prompt(account)
      end
  end
end

main = Main.new
main.run()