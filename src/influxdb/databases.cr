module InfluxDB
  struct Databases
    include Enumerable(Database)
    delegate :query, to: @client

    def initialize(@client : Client)
    end

    def create(name)
      query "CREATE DATABASE #{name}"
      self[name]
    end

    def [](name : String)
      Database.new(@client, name)
    end

    def all
      res = query("SHOW DATABASES")
      dbs = [] of Database
      res[0]["series"][0]["values"].as_a.each do |arr|
        dbs << Database.new(@client, arr[0].as_s)
      end
      dbs
    end

    def each
      all.each { |db| yield db }
    end
  end
end
