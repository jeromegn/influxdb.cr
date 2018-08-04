module InfluxDB
  struct User
    getter name : String
    delegate :query, to: @client

    def initialize(@client : Client, @name)
    end

    def grant(db, permissions = "all")
      query "GRANT #{permissions.upcase} ON #{db} TO #{name}"
      self
    end

    def revoke
      query "REVOKE #{permissions.upcase} ON #{db} TO #{name}"
      self
    end

    def grants
      query "SHOW GRANTS FOR #{name}"
    end

    def password=(password)
      query "SET PASSWORD FOR todd = '#{name}'"
      self
    end

    def drop
      query "DROP USER #{name}"
      true
    end
  end
end
