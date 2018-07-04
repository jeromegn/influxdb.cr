require "../src/influxdb"

influx = InfluxDB::Client.new

blah = influx.databases["blah"]

# p blah

# p blah.write "serie_name", tags: {:blah => "ok_cool"}, fields: {:value => 10}

# blah.write do |points|
#   points.write "many_series", tags: {:from_block => "yes"}, fields: {:value => 1}
#   points.write "many_series", tags: {:from_block => "yes", :second => "ah"}, fields: {:value => 11}
#   points.write "many_series", tags: {:from_block => "yes", :third => "oh"}, fields: {:value => 111}
# end

blah.select.from("many_series").each do |res|
  p res
end
