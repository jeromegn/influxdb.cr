require "./client/*"

module InfluxDB
  class Client
    include Databases
    include Users

    DEFAULT_URL      = "http://localhost:8086"
    DEFAULT_USERNAME = "root"
    DEFAULT_PASSWORD = "root"

    forward_missing_to client

    @client : HTTP::Client?

    def initialize(url = DEFAULT_URL, @username = DEFAULT_USERNAME, @password = DEFAULT_PASSWORD)
      @url = URI.parse(url)
    end

    def host
      @url.host
    end

    def port
      @url.port
    end

    def client
      @client ||= begin
        c = HTTP::Client.new(@url)
        c.basic_auth(@username, @password) if !@username.empty? && !@password.empty?
        c
      end
      @client.not_nil!
    end

    def query(q, db = "")
      params = HTTP::Params.build do |qs|
        qs.add "db", db unless db.empty?
        qs.add "q", q
      end
      resp = client.get "/query?#{params}"
      if resp.status_code == 200
        JSON.parse(resp.body)["results"]
      else
        err_msg = JSON.parse(resp.body)["error"].as_s
        raise Exception.new("InfluxDB error: #{err_msg}")
      end
    end
  end
end
