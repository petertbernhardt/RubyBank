require 'DatabaseHandler'

class Main
  puts "Please enter your name. "
  name = gets.chomp
  puts "Please enter your PIN. "
  pin = gets.chomp
  handler = DatabaseHandler.new("bank.db")
  query = "SELECT name, pin FROM users 
            WHERE name = '#{name}' AND pin = #{pin}"
  data = handler.execute(query)
  puts data
end