require 'bundler'
Bundler.require
require 'sinatra/url_for'

# DataMapper.auto_upgrade!




configure do |c|
  enable :sessions # sessions = {:username => "Clay"}   sessions[:username]
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "app/views")}
  set :scss, :style => :compact
end
require './helpers'
Dir['./app/*/*.rb'].each {|file| require file}

