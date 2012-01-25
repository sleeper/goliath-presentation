#!/usr/bin/env ruby
# encoding: UTF-8

require "bundler/setup"
require 'goliath'
require 'goliath/websocket'
require 'em-http-request'
require 'json'

Encoding.default_internal = "UTF-8"

# Twitter search:
#  curl -d 'track=freemobile' https://stream.twitter.com/1/statuses/filter.json -uUSER:PWD
#
FIREHOSE = "https://stream.twitter.com/1/statuses/filter.json"
USER = "GoliathDemo"
PASS = "g0l14thd3m0"

class WebSocketEndPoint < Goliath::WebSocket
  def on_open(env)
    # Join the channel
    env[:tbuffer] = ""
    env[:subscription] = env.channel.subscribe {|m| env.stream_send(m.force_encoding("BINARY")) }
  end

  def on_message(env, msg)
    case msg
    when /^search ([^\s]+).*$/
      term = $1
      req = {
        :head => {'authorization' => [USER, PASS]},
        :body => {'track' => term }
      }
      http = EventMachine::HttpRequest.new(FIREHOSE).post(req)

      http.errback { puts 'Uh oh' }
      http.stream do |chunk|
        env[:tbuffer] += chunk
        while line = env[:tbuffer].slice!(/.+\r?\n/)
          if line.length > 5
            record = JSON.parse(line)
            env.channel << {:name => record['user']['screen_name'], :tweet => record['text'], :search => term }.to_json
          end
        end
      end
    else
      # Unknown message
    end
  end

  def on_close(env)
    env.channel.unsubscribe(env[:subscription])
  end
end

class SiteIndex < Goliath::API
  def response(env)
    [
      200,
      {"Content-Type"=>"text/html"},
      File.open(Goliath::Application.app_path("static/index.html"),File::RDONLY)
    ]
  end
end

class TwitSock < Goliath::API
  use Rack::Static, :urls => ['/scripts','/images','/css'], :root => Goliath::Application.app_path("static")

  get "/", SiteIndex

  map "/ws", WebSocketEndPoint

end
