module InfluxDB
  class Query
    struct Result
      getter name : String
      getter tags : Tags
      getter fields : Fields

      def initialize(@name, @fields, @tags = Tags.new)
      end

      def time
        @fields["time"]
      end

      def value
        @fields["value"]
      end
    end
  end
end
