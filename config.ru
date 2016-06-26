require 'cuba'
require 'cuba/render'
require 'json'
require 'philote'

SERVER = ENV.fetch('PHILOTE_URL')
Philote.redis = Redic.new(ENV.fetch('REDIS_URL'))

class ChatApp < Cuba
  plugin Cuba::Render

  settings[:render][:views] = 'views'
  settings[:render][:layout] = 'layout'

  use Rack::Static, urls: ['/js'], root: 'public'
end

ChatApp.define do
  on ':room' do |room|
    access_key = Philote::AccessKey.create(read: [room], write: [room])
    render 'room', room: room, token: access_key.token, server: SERVER
  end

  on default do
    render 'home'
  end
end


run ChatApp
