source :rubygems

gem 'sinatra'
gem 'rack'
gem 'sass'

gem 'dm-core'
gem 'dm-migrations'
gem 'bson_ext'
gem 'json' 

gem 'mongo'
gem 'aws-s3', :require => 'aws/s3'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly', '~>0.9.8'
gem 'emk-sinatra-url-for'

group :development do
  gem 'dm-sqlite-adapter'
end

group :production, :test do 
  gem 'dm-postgres-adapter'
end