require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models.rb'
require "sinatra"
require "instagram"
require "date"

enable :sessions

#Action! Following urls must be changed for your callbuck urls which registered on developer tools.
CALLBACK_URL = "http://xxxxx.com/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV['YOUR_CLIENT_ID']
  config.client_secret = ENV['YOUR_CLIENT_SECRET']
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

class Photo
  def initialize()
    puts "/*--- initializing ---*/"
    if (defined?(@@max)).nil?
      @@max = 0
    end
    
    if (defined?(@@num)).nil?
      @@num = [*1..@@max].sample
    end
    
    if (defined?(last_renewed_date)).nil?
      #Default time are set in my (developer's) birtyday ;)
      @@last_renewed_date = Time.local(2015, 10, 04, 00, 00, 00)
    end
    
    puts "Photo/initialize/max #{@@max}"
    puts "Photo/initialize/num #{@@num}"
  end
  
  def extend_max(n)
    @@max += n
  
  end
  
  def renew_param(date)
    @@last_renewed_date = date
    @@num = [*1..@@max].sample
    puts "Photo/renew/last_renewed_date #{@@last_renewed_date}"
    puts "Photo/renew/max #{@@max}"
    puts "Photo/renew/num #{@@num}"
  end
  
  def getmax
    return @@max
  end
    
  def getnum
    return @@num
  end
  
  def gettimer
    return @@last_renewed_date
  end
end

#Below commands are implemented if you renew contents of this program (for the first time)
hoge = Photo.new
puts "=== [Implemented] Photo.new ==="

get '/' do
    #Get photos from an instagram api and put them to the database
    client = Instagram.client(:access_token => session[:access_token])
    
    client.user_recent_media.each do |content|
        
        #IF the contents don't have its caption...
        if (defined?(content.caption.text)).nil?
            Contribution.create({
                url: content.images.standard_resolution.url
            })
        else
            Contribution.create({
                url: content.images.standard_resolution.url, 
                caption: content.caption.text
            })
        end
    end 
    
    #Extend maximam value of the photo array
    hoge.extend_max(20)

    #Below commands are calculating the passing time from last renewal data 
    now_date = Time.now
    puts "now_date #{now_date}"
    puts "last_renewed_date #{hoge.gettimer}"
    
    sabun = now_date - hoge.gettimer
    sabun_h = sabun.to_i/3600
    puts "sabun_h #{sabun_h}"

    if sabun_h > 23
      hoge.renew_param(now_date)
      puts "sabun_h > 23"
    end
    
    #Show the maximum number of database
    @showmax = hoge.getmax
    puts "main/showmax #{@showmax}"

    #Show the selected number in database
    @shownum = hoge.getnum
    puts "main/shownum #{@shownum}"
    
    @whenwasitrenewed = hoge.gettimer
    @imageurl =  Contribution.find(@shownum).url
    @imagecaption = Contribution.find(@shownum).caption
    
    erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/"
end
