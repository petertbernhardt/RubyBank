class Account
  attr_reader :name
  attr_reader :balance
  
  def initialize(name, balance=100)
    @name = name
    @balance = balance
  end
  
  public
  def display_balance(pin_number)
    if pin_number == pin
      puts "Balance: $#{balance}."
    else
      puts pin_error
    end
  end
  
  def withdraw(pin_number, amount)
    if pin_number == pin
      @balance -= amount
      puts "Withdrew #{amount}. New balance: $#{@balance}."
    else
      puts pin_error
    end
  end
  
  private
  def pin
    @pin = 1234
  end
  
  def pin_error
    return "Access denied: incorrect PIN."
  end
end

puts "display and withdraw tests"
checking_account = Account.new("test", 10000)
checking_account.display_balance(1234)
checking_account.withdraw(1234,1)

puts "error test"
error_account = Account.new("bad", 10)
error_account.display_balance(1)