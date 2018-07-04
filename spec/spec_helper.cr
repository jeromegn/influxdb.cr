require "../src/influxdb"
require "spec"

Spec.before_each do
  db.drop
  dbs.create "test"
end

class Runtime
  @dbs : InfluxDB::Databases?
  @db : InfluxDB::Database?

  def client
    @client ||= InfluxDB::Client.new
  end

  def dbs
    (@dbs ||= client.databases).not_nil!
  end

  def db
    (@db ||= dbs["test"]).not_nil!
  end

  INSTANCE = new
end

def client
  Runtime::INSTANCE.client
end

def dbs
  Runtime::INSTANCE.dbs
end

def db
  Runtime::INSTANCE.db
end
