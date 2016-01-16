require 'cuba'
require 'cuba/render'
require 'redic'
require 'securerandom'
require 'json'

$redis = Redic.new(ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))
SERVER = ENV.fetch('WS_SERVER')

class ChatApp < Cuba
  plugin Cuba::Render

  settings[:render][:views] = 'views'
  settings[:render][:layout] = 'layout'

  use Rack::Static, urls: ['/js'], root: 'public'
end

ChatApp.define do
  on ':room' do |room|
    token = SecureRandom.urlsafe_base64

    permissions = {
      read: [room],
      write: [room],
      allowed_uses: 1,
      uses: 0
    }

    $redis.call('SET', "philote:token:#{token}", permissions.to_json)
    render 'room', room: room, token: token, server: SERVER
  end

  on default do
    render 'home'
  end
end


run ChatApp
