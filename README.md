# InfluxDB.cr

InfluxDB driver for Crystal.

## Status: Developer Preview

Working on this from time to time, a lot of missing querying features.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  influxdb:
    github: jeromegn/influxdb.cr
```

## Usage

```crystal
require "influxdb"

client = InfluxDB::Client.new
db = client.databases["db_name"]
```

### Writing data

There are many ways to write data to influxdb.

Write one data point with a value:

```crystal
db.write "your_series", 10 # => true
db.write "your_series", InfluxDB::Fields{:a_field => 100, :value => 10000}
```

Write many data points:

```crystal
db.write do |points|
  points.write "your_series", 10
  points.write "another_series", 100
  points.write "another_series", 1000, InfluxDB::Tags{:a_tag => "hello"}
end # => true
```

Write points with fields, tags and a timestamp:

```crystal
db.write "your_series", InfluxDB::Fields{:a_field => 100, :value => 10000},
  tags: InfluxDB::Tags{:region => "us"}, timestamp: Time.now
```

Write a point asynchronously

```crystal
spawn { db.write "your_series", 10 }
```

## Contributing

1. Fork it ( https://github.com/jeromegn/influxdb.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jeromegn](https://github.com/jeromegn) Jerome Gravel-Niquet - creator, maintainer
