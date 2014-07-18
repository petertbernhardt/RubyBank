require 'DatabaseHandler'

class AccountActions
  attr_reader :name
  attr_reader :balance
  
  def initialize(name)
    handler = DatabaseHandler.new("bank.db")
    @name = name
    @pin = handler.execute("SELECT pin FROM users WHERE name = '#{name}';")[0][0]
    @balance = handler.execute("SELECT balance FROM accounts 
                                JOIN users on accounts.userId = users.userId 
                                WHERE users.name = '#{name}';")[0][0]
  end
  
  public
  def display_balance
    puts "Balance: $#{balance}."
  end
  
  def withdraw(amount)
    if amount.is_a? Integer && check_over(amount)  && amount > 0
      @balance -= amount
      puts "Withdrew #{amount}. New balance: $#{@balance}."
    end
  end
  
  def deposit(amount)
    if amount.is_a? Integer && amount > 0
      @balance += amount
      puts "Deposited #{amount}. New balance: $#{@balance}."
    end
  end
  
  def changePin(newPin)
    if newPin.is_a? Integer 
      @pin = newPin
      puts "Pin changed to #{@pin}"
    else
      puts "Input was not a number"
    end
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