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
    end

    def drop
      query "DROP DATABASE IF EXISTS #{name}"
      true
    end

    def select(fields = "*")
      Query.new(@client, name).select(fields)
    end

    def write(point_value : PointValue, sync = false)
      write [point_value], sync: sync
    end

    def write(point_values : Array(PointValue), sync = false)
      body = String.build do |str|
        point_values.each_with_index do |pv, i|
          pv.to_s(str)
          str << "\n" unless i == point_values.size - 1
        end
      end.strip
      
      if sync
        send_write(body).status_code == 204
      else
        spawn { send_write(body) }
        true
      end
    end

    private def send_write(body)
      @client.post "/write?db=#{name}",
        HTTP::Headers{
          "Content-Type" => "application/octet-stream",
          "User-Agent" => "influxdb.cr v#{InfluxDB::VERSION}"
        },
        body
    end

    def write(series : String, fields : Fields, tags = Tags.new, timestamp : Time? = nil, sync = false)
      timestamp = Time.now if sync == false && timestamp.nil?
      write PointValue.new(series, tags: tags, fields: fields, timestamp: timestamp), sync: sync
    end

    def write(series : String, value : Value, tags = Tags.new, timestamp : Time? = nil, sync = false)
      write series, Fields{:value => value}, tags: tags, timestamp: timestamp, sync: sync
    end

    def write(sync = false)
      pw = PointsWriter.new(sync: sync)
      yield pw
      write pw.points, sync: sync
    end
  end
end
