module InfluxDB
  struct Database
    getter :name
    delegate :query, to: @client

    # @@processed = Channel(HTTP::Client::Response)
    # spawn do
    #   loop do
    #     resp = @@processed.receive
    #   end
    # end

    def initialize(@client : Client, @name : String)
      @mutex = Mutex.new
    end

    # https://docs.influxdata.com/influxdb/latest/query_language/database_management/#delete-a-database-with-drop-database
    def drop
      query "DROP DATABASE #{name}"
      true
    end

    def select(fields = "*")
      Query.new(@client, name).select(fields)
    end

    def write(point_value : PointValue)
      write [point_value]
    end

    def write(point_values : Array(PointValue))
      body = String.build { |str|
        point_values.each_with_index do |pv, i|
          pv.to_s(str)
          str << "\n" unless i == point_values.size - 1
        end
      }.strip

      send_write(body).status_code == 204
    end

    private def send_write(body)
      @mutex.synchronize do
        @client.post "/write?db=#{name}&precision=ms",
          HTTP::Headers{
            "Content-Type" => "application/octet-stream",
          },
          body
      end
    end

    def write(series : String, fields : Fields, tags = Tags.new, timestamp : Time? = nil)
      timestamp = Time.utc if timestamp.nil?
      write PointValue.new(series, tags: tags, fields: fields, timestamp: timestamp)
    end

    def write(series : String, value : Value, tags = Tags.new, timestamp : Time? = nil)
      write series, Fields{:value => value}, tags: tags, timestamp: timestamp
    end

    def write
      pw = PointsWriter.new
      yield pw
      write pw.points
    end
  end
end
