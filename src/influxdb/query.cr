require "./query/*"

module InfluxDB
  class Query
    include Enumerable(Result)

    property! fields : String
    property! measurement : String

    def initialize(@client : Client, @db : String)
      @results = [] of Result
    end

    def select(fields = "*")
      @fields = fields
      self
    end

    def from(measurement : String)
      @measurement = measurement
      self
    end

    def each
      execute
      @results.each { |pv| yield pv }
    end

    def execute
      parse_results @client.query(build_query, db: @db)
    end

    private def build_query
      String.build do |str|
        str << "SELECT #{fields} FROM #{measurement}"
      end
    end

    private def parse_results(results)
      @results = [] of Result
      results[0]["series"].each do |series|
        name = series["name"].as_s
        columns = series["columns"]
        series["values"].each do |value|
          fields = Fields.new
          i = 0
          value.each do |v|
            fields[columns[i].as_s] = v
            i += 1
          end
          @results << Result.new(name, fields)
        end
      end
    end
  end
end
