module InfluxDB
  class Client
    module Users
      def users(db = "")
        InfluxDB::Users.new(self, db)
      end
    end
  end
end
