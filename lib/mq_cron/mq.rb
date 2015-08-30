require 'bunny' 

require 'mq_cron/logger'

module MqCron
  class Mq
    attr_reader :settings, :callback

    def initialize(settings, callback)
      @settings = settings
      @callback = callback
      @logger = MqCron::Logger.instance
    end

    def connection
      @connection ||= Bunny.new(@settings).start
    end

    def channel
      @channel ||= connection.create_channel
    end

    def queue
      return @queue if @queue

      @logger.info "Create queue #{queue_name}"
      @queue ||= channel.queue(queue_name, :exclusive => true)
      @queue.subscribe do |delivery_info, metadata, payload|
        callback.call(delivery_info, metadata, payload)
      end
      @queue
    end

    def bind(exchange, routing_key)
      unless connection.exchange_exists?(exchange)
        channel.topic(exchange, :auto_delete => true)
      end
      @logger.info "Bind to #{exchange} for #{routing_key}"
      queue.bind(exchange, :routing_key => routing_key)
    end

    def close
      connection.close
    end

    private

    def queue_name
      "#{self.class.to_s.split("::").first.downcase}-#{Socket.gethostname}-#{Process.pid}"
    end

  end
end
