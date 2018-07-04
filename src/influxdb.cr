require "uri"
require "http"
require "json"
require "./influxdb/*"

module InfluxDB
  alias Key = String | Symbol
  alias Value = Int32 | Int64 | Float32 | Float64 | String | Bool
  alias Tags = Hash(Key, Value)
  alias Fields = Hash(Key, Value)
end
