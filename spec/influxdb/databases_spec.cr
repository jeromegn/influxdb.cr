require "../spec_helper"

describe InfluxDB::Databases do
  # dbs is defined in the spec_helper

  describe "#create" do
    it "creates a database" do
      db = dbs.create("test2")
      db.should be_a(InfluxDB::Database)
      db.name.should eq("test2")
      db.drop
    end
  end

  describe "#[]" do
    it "gets a database" do
      dbs["test-2"].should be_a(InfluxDB::Database)
    end
  end

  describe "enumerability" do
    it "is enumerable" do
      db1 = dbs.create "test1"
      db2 = dbs.create "test2"
      names = dbs.map(&.name)
      names.should contain "test1"
      names.should contain "test2"
      ["test", "test2"].each do |db|
        dbs[db].drop
      end
    end
  end
end
