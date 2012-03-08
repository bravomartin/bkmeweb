
before do
  cache_control :public, :must_revalidate, :max_age => 60*60*24
	
  config = {:server => ENV['MONGOLAB_SERVER'] ||  MONGOLAB_SERVER,
	              :port => ENV['MONGOLAB_PORT'] || MONGOLAB_PORT ,
								:user =>ENV['MONGOLAB_USER'] || MONGOLAB_USER ,
								:password => ENV['MONGOLAB_PASS'] || MONGOLAB_PASS,
								:db => "bkme"
								}
								
	MongoBase.connect config
  @users_hash = MongoBase.hash_users()
  @users = MongoBase.list_users()
  @root = url_for "/", :full
  

  

end

get '/' do
  @gets = MongoBase.find :all

  @gets = @gets.first(40)
  erb :home
end

["/about", "/join", "/faq", "/activity"].each do |path|
  get path+"/?:period?" do
    erb path[1..-1].to_sym
  end
end




get '/user/:user_name' do
  @gets = MongoBase.find(:user_name => params[:user_name])
  @stats = how_many(params[:user_name]).to_a.reverse
  @user = MongoBase.find_one(:user_name => params[:user_name])
  erb :user_profile
end


get '/get/:tweet_id' do
  @get = MongoBase.find_one(:tweet_id => params[:tweet_id])
  if !@get.nil?
    erb :single_get
  else
    erb :notfound
  end
end

get '/gets/?:page?' do
  @gets = MongoBase.find :all
  @total = (@gets.count/30).ceil
  if params[:page].nil?
      @gets = @gets.first(30)
      erb :gets
  else
    @page = params[:page].to_i
    return erb :notfound if @page == 0
    @gets = @gets[@page*30, 30]
    return erb :notfound if @gets.nil?
    erb :gets
  end
end

get '/receive/?' do

  return params.inspect

end

post '/receive/?' do
  content_type :json

  
  # return params.to_json

  now = Time.new
  # time = params[:timestamp]
  time = now.to_a[0..5].reverse().join()
  imgBase64 = params[:image]
  lat = params[:geolocation][:lat]
  lon = params[:geolocation][:lon]
  name = "#{time}_lat:#{lat}_lon:#{lon}"



File.open('tempfile.jpg', 'wb') do|f|
  f.write(Base64.decode64(params[:img]))
end

  # AWS::S3::Base.establish_connection!(
  #     :access_key_id     => ENV['AWS_ID'] || AWS_ID,
  #     :secret_access_key => ENV['AWS_SECRET'] || AWS_SECRET
  #   )
  
  AWS::S3::S3Object.store('test/#{name}.jpg', imgBase64, 'img.bkme.org', :access => :public_read)

  return {:filename => "http://img.bkme.org/test/#{name}.jpg"}.to_json

end



#   SASS
#---------------------------------------

get '/stylesheets/:stylesheet.css' do
  scss params[:stylesheet].to_sym
end

#   404
#---------------------------------------

not_found do
  erb :notfound
end





# REPORTS DATA
get '/data/?:user?/?:period?/?' do
  response = []
  users =[]
  periods = ["lasthour","lastday","lastweek","lastmonth","ever"]
  
  if params[:user] or params[:period]
    content_type :json
    if params[:user] == "all"
      data = MongoBase.find :all 
    elsif periods.include? params[:user]
        return "Error! you must indicate the user or \"all\" before defining the period.
Like this: http://www.bkme.org/data/{user}/{period}
        "
    else
      data = MongoBase.find(:user_name => params[:user])
      return "@#{params[:user]} hasn't gotten any cars yet." if data.nil?
    end
    
    if periods.include? params[:period]
      data = filter_by_period(data,params[:period])
    else 
      data = data
    end
    
    data.each do |d|
      d.delete("response")
      d.delete("_id")
      response << d
    end
    response.to_json

  else 
    "this is the world"
    erb :data
  end
      
  
  

end

