module InfluxDB
  struct PointValue
    getter :series, :tags, :fields, :timestamp

    def initialize(
      @series : String,
      @fields : Fields = Fields.new,
      @tags : Tags = Tags.new,
      @timestamp : Time? = nil
    )
    end

    def to_s(io)
      io << escape_key(@series)
      io << ",#{parse_tags}" unless @tags.empty?
      io << " #{parse_fields}"
      io << " #{parse_timestamp}" unless @timestamp.nil?
    end

    private def parse_series
      @series.gsub(/\s/, "\ ").gsub(",", "\,")
    end

    private def parse_tags
      parse_hash(@tags)
    end

    private def parse_fields
      parse_hash(@fields, true)
    end

    private def parse_timestamp
      @timestamp.not_nil!.to_unix_ms
    end

    private def parse_hash(h, quote_escape = false)
      return "" if h.empty?
      map(h, quote_escape).join(",")
    end

    private def map(h, quote_escape)
      h.map do |k, v|
        key = escape_key(k)
        val = v.is_a?(String) ? escape_value(v, quote_escape) : escape_non_string(v)
        "#{key}=#{val}"
      end
    end

    # when passing an integer to influxdb, we must suffix it with "i", or else
    # it will assume v is a float. type misalignment in a series is something
    # influxdb does not allow, and we get an error
    private def escape_non_string(v : Int)
      "#{v}i"
    end

    # when v is a float or etc, the "i" suffix is not required
    private def escape_non_string(v)
      v
    end

    private def escape_key(key)
      key.to_s.gsub(/\s/, "\ ").gsub(",", "\,")
    end

    private def escape_value(value, quote_escape)
      val = value
        .gsub(/\s/, "\ ")
        .gsub(",", "\,")
        .gsub("\"", "\\\"")
      val = %("#{val}") if quote_escape
      val
    end
  end
end
