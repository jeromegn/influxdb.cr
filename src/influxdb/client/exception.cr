require "./exceptions/*"

module InfluxDB
  class Client
    class Exception < ::Exception
    end
  end
end
