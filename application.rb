require 'bundler'
Bundler.require
require 'sinatra/url_for'
require 'yaml'
# DataMapper.auto_upgrade!

yaml = YAML.load_file "keys.yaml"


configure do |c|
  enable :sessions # sessions = {:username => "Clay"}   sessions[:username]
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "app/views")}
  set :scss, :style => :compact
end

require './helpers'
require'./keys'
Dir['./app/*/*.rb'].each {|file| require file}


=begin
@resizer = D Dragonfly::Middleware, :images 
@resizer.configure_with(Dragonfly::Config::RMagickImages) 
uid = @resizer.store(File.new('public/images/image.jpg')) 

@resizer.configure_with(Dragonfly::Config::RMagickImages) do |c| 
      c.url_handler.path_prefix = '/images' 
  end

=end






