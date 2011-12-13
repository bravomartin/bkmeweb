module MongoBase
	class << self
	
		def connect(config)
			@db = Mongo::Connection.new(config[:server],config[:port] || 27017).db(config[:db])
      @db.authenticate(config[:user],config[:password])
      @reports = @db.collection("records")
		end

		def find(search)
			if search == :all
				#return all
				data = @db.collection("records").find.to_a
				return nil_or_array(data)
			else
				return find_with_criteria(search)
			end
		end
		
		def find_one(search)
				return find_one_with_criteria(search)
		end
		
    def hash_users()
      @users = {}
      all = @db.collection("records").find.to_a
      all.each do |d|
        name = d["user_name"]
        if @users.include?(name)
          @users[name]+=1
        else
          @users[name]=1
        end 
      end
      return @users
    end

    def list_users()
      users_array = []
      hash_users().each do |u|
        users_array << [u[0], u[1]]
      end
      return users_array.sort{|a,b| b[1]<=>a[1]}
    end
    
		def update(yasi)
			stringify_keys(yasi)
			# handle author first
			if yasi["author"]
				stringify_keys(yasi["author"])
				author = @db.collection("authors").find_one(yasi["author"])
				# if the author does not exist, then create one 
				unless author
					author = @db.collection("records").save(yasi["author"])
				end
				yasi["author"] = author
			end

			# save with the yasi with the author
			# once again, please validate before save
			# this is for educational purpose only.
			@db.collection("records").save(yasi)
		end

		def delete(id)
			victim = @db.collection("records").find_one(Mongo::ObjectID.from_string(id))
			@db.collection("records").remove(victim) if victim
		end



    # ===============================
    # = from now on this is private =
    # ===============================
		private

		def find_with_criteria(search)
			search = stringify_keys(search)
			if search["user_name"]
			  if  search["user_name"] == "all"
		      result = hash_users()
		    else
				  result = @reports.find(search).to_a
				end
				return nil_or_array(result)
			elsif search["tweet_id"]
			  search["tweet_id"] = search["tweet_id"].to_i
			  result = @reports.find(search).to_a
				return nil_or_array(result)
			else
				result = @db.collection("records").find(search).to_a
				return nil_or_array(result)
			end
		end
		
		def find_one_with_criteria(search)
			search = stringify_keys(search)
			if search["user_name"]
				result = @reports.find_one(search)
				return result
			elsif search["tweet_id"]
			  search["tweet_id"] = search["tweet_id"].to_i
			  result = @reports.find_one(search)
				return result
			else
				result = @db.collection("records").find(search).to_a
				return nil_or_array(result)
			end
		end

		def stringify_keys(hash)
      newhash = {}
      hash.each do |key,val|
        if val.is_a?( Hash )
          newhash[ key.to_s ] = stringify_keys( val )
        else
          newhash[ key.to_s ] = val
        end
      end
      return newhash
    end

		def nil_or_array(result)
			if result.size == 0
				return nil
			else
				return result
			end
		end

	end
end
