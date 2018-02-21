$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'xdcc'

client = XDCC::Client.new('irc.rizon.net', channel: 'bots', nickname: 'baseballlover7234')
client.connect
client.connect

sleep 2

client.disconnect
sleep 5
client.connect
sleep 3
client.disconnect
sleep 1