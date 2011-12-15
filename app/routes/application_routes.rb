
before do
	config = {:server => "dbh84.mongolab.com",
	              :port => 27847,
								:db => "bkme",
								:user =>"bkme",
								:password => "youwerebiked1"}
	MongoBase.connect config
  @users_hash = MongoBase.hash_users()
  @users = MongoBase.list_users()
  @app = Dragonfly[:images].configure_with(:imagemagick)
  
end

get '/' do
  @gets = MongoBase.find :all

  @gets = @gets.first(30)
  erb :home
end

get '/about/?' do
  erb :about
end

get '/join/?' do
  erb :join
end
get '/faq/?' do
  erb :faq
end
get '/map/?' do
  erb :map
end



get '/user/:user_name' do
  @user = MongoBase.find_one(:user_name => params[:user_name])
  @gets = MongoBase.find(:user_name => params[:user_name])
  erb :user_profile
end


get '/get/:tweet_id' do
  @get = MongoBase.find_one(:tweet_id => params[:tweet_id])
  erb :gets
end





#   SASS
#---------------------------------------

get '/stylesheets/style.css' do
  scss :style
end

#   404
#---------------------------------------

not_found do
  content_type :html
  erb :notfound
end





# REPORTS DATA
get '/data/?' do
  content_type :json
  response = []
  users =[]
  
  if params[:user] 
    data = MongoBase.find(:user_name => params[:user])
    return "@#{params[:user]} hasn't gotten any cars yet." if data.nil?
    
  elsif params[:period]
       period = params[:period]
       return "not serving period=#{period} yet"
  else 
    data = MongoBase.find :all 
  end
  
  data.each do |d|
    d.delete("response")
    d.delete("_id")
    response << d
  end
  response.to_json
end

