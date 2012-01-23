#!/usr/bin/env ruby

require "bundler/setup"
require 'goliath'

# Twitter search:
#  curl -d 'track=freemobile' https://stream.twitter.com/1/statuses/filter.json -uUSER:PWD
#

class TwitSock < Goliath::API

  def response(env)
    [200, {}, "Hello World"]
  end

end
