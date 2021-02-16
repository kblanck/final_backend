class Location < ApplicationRecord
    if(ENV['DATABASE_URL'])
        uri = URI.parse(ENV['DATABASE_URL'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
      else
        DB = PG.connect(host: "localhost", port: 5432, dbname: 'final_development')
      end

      def self.all
        results = DB.exec("SELECT * FROM locations;")
        return results.map do |result|
            {
                "id" => result["id"].to_i,
                "address" => result["address"],
                "city" => result["city"],
                "state" => result["state"],
                "zip" => result["zip"].to_i,
                "area" => result["area"]
            }
        end
      end

      def self.find(id)
        results = DB.exec("SELECT * FROM locations WHERE id=#{id};")
        return {
            "id" => results.first["id"].to_i,
            "address" => results.first["address"],
            "city" => results.first["city"],
            "state" => results.first["state"],
            "zip" => results.first["zip"].to_i,
            "area" => results.first["area"]
        }
    end

    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO locations(address, city, state, zip, area)
                VALUES('#{opts["address"]}', '#{opts["city"]}', '#{opts["state"]}', #{opts["zip"]}, '#{opts["area"]}')
                RETURNING id, address, city, state, zip, area;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "address" => results.first["address"],
            "city" => results.first["city"],
            "state" => results.first["state"],
            "zip" => results.first["zip"].to_i,
            "area" => results.first["area"]
        }
    end

    def self.delete(id)
        results = DB.exec("DELETE FROM locations WHERE id=#{id};")
        return { "deleted" => true }
    end

    def self.update(id, opts)
        results = DB.exec(
            <<-SQL
                UPDATE locations
                SET address='#{opts["address"]}', city='#{opts["city"]}', state='#{opts["state"]}', zip=#{opts["zip"]}, area='#{opts["area"]}'
                WHERE id=#{id}
                RETURNING id, address, city, state, zip, area
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "address" => results.first["address"],
            "city" => results.first["city"],
            "state" => results.first["state"],
            "zip" => results.first["zip"].to_i,
            "area" => results.first["area"]
        }
    end

end