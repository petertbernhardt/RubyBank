require 'sqlite3'

class DatabaseHandler
  
  def initialize(filename)
    @database = SQLite3::Database.open(filename)
  end
  
  public
  def execute(query)
    @database.execute(query)
  end
end

handler = DatabaseHandler.new("bank.db")
handler.execute("INSERT INTO users (name, pin) 
                 VALUES ('Peter', 1992)")
rows = handler.execute("SELECT * FROM users")
puts rows