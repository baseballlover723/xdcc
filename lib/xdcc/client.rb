module XDCC
  class Client
    def initialize(server, channel: nil, nickname: "Guest-#{Time.now.to_i}")
      self.bot = Cinch::Bot.new do
        configure do |c|
          c.server = server
          c.nick = nickname
          c.channels = ["##{channel}"] if channel
          c.plugins.plugins = [XDCCHandler]
        end
      end
    end
  end
end
# https://github.com/inket/RubyXDCCGetter
