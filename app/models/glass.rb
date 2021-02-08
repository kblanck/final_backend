class Glass < ApplicationRecord

    if(ENV['https://dorby-barker-backend.herokuapp.com/glasses'])
        uri = URI.parse(ENV['https://dorby-barker-backend.herokuapp.com/glasses'])
        DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
      else
        DB = PG.connect(host: "localhost", port: 5432, dbname: 'final_development')
      end

    def self.all
        results = DB.exec("SELECT * FROM glasses;")
        return results.map do |result|
            {
                "id" => result["id"].to_i,
                "name" => result["name"],
                "price" => result["price"].to_i,
                "description" => result["description"]
            }
        end
    end

    def self.find(id)
        results = DB.exec("SELECT * FROM glasses WHERE id=#{id};")
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"]
        }
    end

    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO glasses(name, price, description)
                VALUES('#{opts["name"]}', #{opts["price"]}, '#{opts["description"]}')
                RETURNING id, name, price, description;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"]
        }
    end

    def self.delete(id)
        results = DB.exec("DELETE FROM glasses WHERE id=#{id};")
        return { "deleted" => true }
    end

    def self.update(id, opts)
        results = DB.exec(
            <<-SQL
                UPDATE glasses
                SET name='#{opts["name"]}', price=#{opts["price"]}, description='#{opts["description"]}'
                WHERE id=#{id}
                RETURNING id, name, price, description
            SQL
        )
                return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"]
        }
    end

end