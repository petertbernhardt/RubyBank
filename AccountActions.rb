class AccountActions
  attr_reader :name
  attr_reader :balance
  
  def initialize(name, balance=100)
    @name = name
    @balance = balance
  end
  
  public
  def display_balance(pin_number)
    if check_pin(pin_number)
      puts "Balance: $#{balance}."
    end
  end
  
  def withdraw(pin_number, amount)
    if check_pin(pin_number) && check_over(amount)
      @balance -= amount
      puts "Withdrew #{amount}. New balance: $#{@balance}."
    end
  end
  
  def deposit(pin_number, amount)
    if check_pin(pin_number)
      @balance += amount
      puts "Deposited #{amount}. New balance: $#{@balance}."
    end
  end
  
  def changePin(newPin)
    # do stuff here
  end
  
  private
  def pin
    @pin = 1234
  end
  
  def pin_error
    return "Access denied: incorrect PIN."
  end
  
  def check_pin(pin_number)
    if pin_number == pin
      true
    else
      puts pin_error
      false
    end    
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