require "../spec_helper"

describe InfluxDB::Database do
  describe "#drop" do
    it "drops the database" do
      db = dbs.create("test_hello")
      db.drop
      dbs.map(&.name).should_not contain("test_hello")
    end
  end

  describe "#select" do
    it "returns a Query instance" do
      db.select.should be_a(InfluxDB::Query)
    end

    it "optionally uses the supplied argument as the select" do
      q = db.select("hello")
      q.fields.should eq("hello")
    end
  end

  describe "#write" do
    it "with PointValue" do
      pv = InfluxDB::PointValue.new("some_series", InfluxDB::Fields{:value => 10})
      db.write(pv).should eq(true)
    end

    it "with PointValue-like attributes" do
      db.write("some_series", InfluxDB::Fields{:value => 10}).should eq(true)
    end

    it "with only a value" do
      db.write("some_series", 100).should eq(true)
    end

    it "with many values" do
      db.write { |points|
        points.write "many_series", InfluxDB::Fields{:value => 1}, tags: {:from_block => "yes"}
        points.write "many_series", InfluxDB::Fields{:value => 11}, tags: {:from_block => "yes", :second => "ah"}
        points.write "many_series", InfluxDB::Fields{:value => 111}, tags: {:from_block => "yes", :third => "oh"}
      }.should eq(true)
    end
  end
end
