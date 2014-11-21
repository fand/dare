#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'
require 'twitter'

config = open './config.json' do |io|
  JSON.parse(io.read, {:symbolize_names => true})
end

client = Twitter::REST::Client.new config

target_user = client.user config[:target_user]
name = target_user.name

exit() if config[:name] == name

count = config[:count] || 1

client.update_profile :name => name
client.update "#{name} に名前変えた" + ('　' * count)
client.update "@#{target_user.screen_name} え、誰？" + ('？' * count)

config[:name] = name
config[:count] = (count + 1) % 10
open './config.json', 'w' do |io|
  JSON.dump(config, io)
end
