helpers do
    
    def tweet_search(term, format = "array")
      return term
    end

    def hi(text)
      "Module Helpers: Hola #{text}"
    end
    
    def filter_by_period(data,period)
      return data if period == "ever"
      n = Time.now
      range = 0
      filtered = []
      range = n - 60*60 if period == "lasthour"
      range = n - 60*60*24 if period == "lastday"
      range = n - 60*60*24*7 if period == "lastweek"
      range = n - 60*60*24*30 if period == "lastmonth"
      
      data.each do |r|
        t = r["created_at"]
        t = Time.parse(t) unless t.class == Time
        filtered << r if t > range
      end
      return filtered
    end
    
    def how_many(user = nil)
          n = Time.now
          lasthour = n - 60*60
          lastday = n - 60*60*24
          lastweek = n - 60*60*24*7
          lastmonth = n - 60*60*24*30 
          if user.nil?
            allusers = {}
            
            list_users().each do |u|
              count = {}
              count["last hour"] = 0
              count["last day"] = 0
              count["last week"] = 0 
              count["last month"] = 0
              count["ever"] = 0
              
              MongoBase.find(:user_name => u[0]).each do |e|
                t = e["created_at"]
                t = Time.parse(t) unless t.class == Time
                count["last hour"] += 1 if t > lasthour
                count["last day"] += 1 if t > lastday
                count["last week"] += 1 if t > lastweek
                count["last month"] += 1 if t > lastmonth
                count["ever"] += 1
              end
              allusers[u[0]] = count
            end
            return allusers        
          else
            how_many = {}
            how_many["last hour"] = 0
            how_many["last day"] = 0
            how_many["last week"] = 0 
            how_many["last month"] = 0
            how_many["ever"] = MongoBase.find(:user_name => user).count()
    
            MongoBase.find(:user_name => user).each do |e|
              t = e["created_at"]
              t = Time.parse(t) unless t.class == Time
              how_many["last hour"] += 1 if t > lasthour
              how_many["last day"] += 1 if t > lastday
              how_many["last week"] += 1 if t > lastweek
              how_many["last month"] += 1 if t > lastmonth
            end
            return how_many
          end
        end
    

end

