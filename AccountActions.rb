require 'DatabaseHandler'

class AccountActions
  attr_reader :name
  attr_reader :balance
  
  def initialize(name)
    @handler = DatabaseHandler.new("bank.db")
    @name = name
    @pin = @handler.execute("SELECT pin FROM users WHERE name = '#{name}';")[0][0]
    @balance = @handler.execute("SELECT balance FROM accounts 
                                JOIN users on accounts.userId = users.userId 
                                WHERE users.name = '#{name}';")[0][0]
  end
  
  public
  def display_balance
    puts "Balance: $#{balance}."
  end
  
  def withdraw(amount)
    if amount.is_a?(Integer) && check_over(amount)  && amount > 0
      @balance -= amount
      @handler.execute("UPDATE accounts
                        SET balance = #{@balance} 
                        WHERE userId IN
                        (SELECT userId FROM users
                        WHERE name = '#{@name}');")
      puts "Withdrew #{amount}. New balance: $#{@balance}."
    end
  end
  
  def deposit(amount)
    if amount.is_a?(Integer) && amount > 0
      @balance += amount
      @handler.execute("UPDATE accounts
                        SET balance = #{@balance}
                        WHERE userId IN
                        (SELECT userId FROM users
                        WHERE name = '#{@name}');")
      puts "Deposited #{amount}. New balance: $#{@balance}."
    end
  end
  
  def changePin(newPin)
    if newPin.is_a?(Integer) 
      @pin = newPin
      @handler.execute("UPDATE users 
                        SET pin = #{@pin} 
                        WHERE name = '#{@name}';")
      puts "Pin changed to #{@pin}"
    else
      puts "Input was not a valid number"
    end
  end
  
  def transfer(person)
    otherBalance = @handler.execute("SELECT balance FROM accounts 
                                    JOIN users on accounts.userId = users.userId 
                                    WHERE users.name = '#{person}';")
    if otherBalance.size != 0
      otherBalance = otherBalance[0][0]
      puts "How much would you like to transfer to #{person}'s account? "
      amount = gets.to_i
      if check_over(amount) && amount > 0
        # everything is good, transfer!
        puts "Are you sure you want to transfer #{amount} to #{person}'s account? Y/N "
        choice = gets.chomp.downcase[0]
        if choice == "y"
          @balance -= amount
          otherBalance += amount
          @handler.execute("UPDATE accounts 
                            SET balance = #{@balance} 
                            WHERE userId IN 
                            (SELECT userId FROM users 
                            WHERE name = '#{@name}');")
          @handler.execute("UPDATE accounts 
                            SET balance = #{otherBalance} 
                            WHERE userId IN 
                            (SELECT userId FROM users 
                            WHERE name = '#{person}');")
          puts "Transferred #{amount} to #{person}'s account."
          puts "Your new balance is #{@balance}."
        else
          transfer(person)
        end
      end
    else
      puts "We're sorry, but #{person} doesn't have an account with us."
    end
  end
  
  def setBal(amount)
    @balance = amount
  end
  
  def setPin(pin)
    @pin = pin
  end
  
  private
  def pin_error
    return "Access denied: incorrect PIN."
  end
  
  def check_over(amount)
    if amount > @balance
      puts "Not enough money in account to complete the withdrawal."
      false
    else
      true
    end
  end
end

=begin
puts "display and withdraw tests"
checking_account = AccountActions.new("test", 10000)
checking_account.display_balance(1234)
checking_account.withdraw(1234,1)

puts "error test"
error_account = AccountActions.new("bad", 10)
error_account.display_balance(1)

puts "deposit test"
deposit = AccountActions.new("d")
deposit.deposit(1234,10)

puts "overdraw test"
over = AccountActions.new("a",10)
over.withdraw(1234,11)

puts "change pin test"
test = AccountActions.new("a")
test.changePin(1)
=end