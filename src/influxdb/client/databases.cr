module InfluxDB
  class Client
    module Databases
      def databases
        InfluxDB::Databases.new(self)
      end
    end
  end
end
