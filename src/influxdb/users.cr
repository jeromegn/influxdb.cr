module InfluxDB
  struct Users
    include Enumerable(User)
    delegate :query, to: @client

    getter db : String

    def initialize(@client : Client, @db = "")
    end

    def create(name, password, permissions = "all")
      query "CREATE USER #{name} WITH PASSWORD '#{password}'"
      user = self[name]
      user.grant(db, permissions) unless db.empty?
      user = self[name]
      user
    end

    def [](name : String)
      User.new(@client, name)
    end

    def all
      res = query("SHOW USERS")
      users = [] of User
      res[0]["series"][0]["values"].each do |arr|
        users << User.new(@client, arr[0])
      end
      users
    end

    def each
      all.each { |db| yield db }
    end
  end
end
