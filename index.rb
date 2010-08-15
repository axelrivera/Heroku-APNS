require 'rubygems'
require 'sinatra'

## For apns_on_rails requires this ##
require 'active_record'
require 'action_view'

if defined?(ENV['RACK_ENV']) && ENV['RACK_ENV'] == "production"
 dbconfig = YAML.load(File.read('config/database.yml'))
 ActiveRecord::Base.establish_connection dbconfig['production']
 RAILS_ENV = "production"
 RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}")
else
 dbconfig = YAML.load(File.read("config/local-database.yml"))
 ActiveRecord::Base.establish_connection(dbconfig)

 RAILS_ENV = "production"
 RAILS_ROOT = File.dirname(__FILE__)
end

require 'apn_on_rails'

## My device code strips out the < > and the spaces, but APN expects it, so we have to add them back :P
## If you don't do this in your app then you can remove this function
def format_token(token)
  t_re = Regexp.new(/^([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})([a-z0-9]{8})$/)
  t_data = t_re.match(token)
  return t_data ? t_data.captures.join(" ") : nil
end

get '/' do
  "Hello world"
end

post '/register' do
  device = APN::Device.create(:token => format_token(params[:token]))
  "registered"
end

post '/message' do
  device = APN::Device.find_by_token(format_token(params[:token]))
  unless device
    status 400
    "No device found"
  else
    notification = APN::Notification.new
    notification.device = device
    notification.badge = params[:badge].to_i
    notification.sound = true
    notification.alert = params[:message]
    notification.save
  end
end

get '/deliver' do
  APN::Notification.send_notifications
end

get '/feedback' do
  APN::Feedback.process_devices
end