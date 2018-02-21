require 'cinch'

module XDCC
  class Client
    attr_accessor :bot
    attr_accessor :connected
    alias_method :connected?, :connected
    @mutex # Mutex
    @connection_resource # ConditionVariable

    def initialize(server, channel: nil, nickname: "Guest-#{Time.now.to_i}")
      this = self
      @mutex = mutex = Mutex.new
      @connection_resource = connection_resource = ConditionVariable.new
      @connected = false

      @bot = Cinch::Bot.new do
        configure do |c|
          c.server = server
          c.nick = nickname
          c.channels = ["##{channel}"] if channel
        end
        on :connect do |m|
          mutex.synchronize {
            this.connected = true
            connection_resource.signal
          }
        end
      end
      @bot.loggers.level = :info
    end

    def connect
      @mutex.synchronize do
        if connected?
          @bot.info('Already connected')
          return
        end
      end

      Thread.new @bot, &:start
      @mutex.synchronize {@connection_resource.wait @mutex}
      @bot.info("Connected to #{@bot.config.server}:#{@bot.config.port}")
    end

    def disconnect
      @mutex.synchronize do
        if !connected?
          @bot.info "Not connected"
          return
        end
      end
      @bot.quit
      @mutex.synchronize {@connected = false}
      @bot.info "Disconnected from #{@bot.config.server}:#{@bot.config.port}"
    end
  end
end
