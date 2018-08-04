module InfluxDB
  class PointsWriter
    getter :points

    def initialize(@sync = false)
      @points = [] of PointValue
    end

    def write(series : String, fields : Fields, tags = Tags.new, timestamp : Time? = nil)
      timestamp = Time.now if @sync == false && timestamp.nil?
      _tags = Tags.new
      tags.each { |k, v| _tags[k] = v }
      @points << PointValue.new(series, fields: fields, tags: _tags, timestamp: timestamp)
    end

    def write(series : String, value : Value, tags = Tags.new, timestamp : Time? = nil)
      timestamp = Time.now if @sync == false && timestamp.nil?
      @points << PointValue.new(series, fields: Fields{:value => value}, tags: tags, timestamp: timestamp)
    end
  end
end
