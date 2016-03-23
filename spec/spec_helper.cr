require "webmock"
require "../src/influxdb"
require "spec"

WebMock.allow_net_connect = true

Spec.before_each do
  db.drop
  dbs.create "test"
end

def client; @@client ||= InfluxDB::Client.new; end
def dbs; @@dbs ||= client.databases; end
def db; @@db ||= dbs["test"]; end