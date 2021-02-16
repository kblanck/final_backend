class Glass < ApplicationRecord

    if(ENV['DATABASE_URL'])
        uri = URI.parse(ENV['DATABASE_URL'])
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
                "description" => result["description"],
                "img_url" => result["img_url"],
                "inventory" => result["inventory"].to_i,
            }
        end
    end

    def self.find(id)
        results = DB.exec("SELECT * FROM glasses WHERE id=#{id};")
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"],
            "img_url" => results.first["img_url"],
            "inventory" => results.first["inventory"].to_i
        }
    end

    def self.create(opts)
        results = DB.exec(
            <<-SQL
                INSERT INTO glasses(name, price, description, img_url, inventory)
                VALUES('#{opts["name"]}', #{opts["price"]}, '#{opts["description"]}', '#{opts["img_url"]}', #{opts["inventory"]})
                RETURNING id, name, price, description, img_url, inventory;
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"],
            "img_url" => results.first["img_url"],
            "inventory" => results.first["inventory"].to_i
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
                SET name='#{opts["name"]}', price=#{opts["price"]}, description='#{opts["description"]}', img_url='#{opts["img_url"]}', inventory=#{opts["inventory"]}
                WHERE id=#{id}
                RETURNING id, name, price, description, img_url, inventory
            SQL
        )
        return {
            "id" => results.first["id"].to_i,
            "name" => results.first["name"],
            "price" => results.first["price"].to_i,
            "description" => results.first["description"],
            "img_url" => results.first["img_url"],
            "inventory" => results.first["inventory"].to_i
        }
    end

    def self.bought(glasses_id)
        results = DB.exec(
            <<-SQL
                UPDATE glasses
                SET inventory = inventory - 1
                WHERE id=#{glasses_id}
            SQL
        )
    end
end