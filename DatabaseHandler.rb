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
# peter
# handler.execute("INSERT INTO users VALUES (1, 'Peter', 1992);")
# handler.execute("INSERT INTO accounts VALUES (1, 100, 1);")
# seth
# handler.execute("INSERT INTO users VALUES (2, 'Seth', 666);")
# handler.execute("INSERT INTO accounts VALUES (2, 666, 2);")                                  