module MqCron
  class Tab

    EVENTS=[:connect, :disconnect, :reconnect]

    attr_reader :env, :event, :entry, :url

    def initialize(crontab, options={})
      @crontab = crontab
      @options = options
      @env = {}
      @event = {}
      @entry = {}
      @url = ENV['RABBITMQ_URL'] || 'amqp://localhost'

      parse
    end

    def parse
      @crontab.each_line { |line| parseline(line) }
    end

    def parseline(line)
      line.match(/^\s*(#.*)?$/) do |m|
        return
      end
      line.match(/^(?<key>\w+)=(?<q>['"]?)(?<value>.*)\k<q>$/) do |m|
        if m[:key] == 'RABBITMQ_URL'
          @url = m[:value]
        else
          @env[m[:key].to_sym] = m[:value]
        end
        return
      end
      line.match(/^@(?<event>\w+)\s+(?<cmd>.*)$/) do |m|
        unless EVENTS.include?(m[:event].to_sym)
          raise ArgumentError, "Unknown event @#{m[:event]}"
        end
        @event[m[:event].to_sym] ||= []
        @event[m[:event].to_sym] << m[:cmd]
        return
      end
      line.match(/^(?<exchange>[\w\.]+)\s+(?<routingkey>[\w\.\#\*]+)\s+(?<cmd>.+)$/) do |m|
        @entry[m[:exchange]] ||= {}
        @entry[m[:exchange]][m[:routingkey]] ||= []
        @entry[m[:exchange]][m[:routingkey]] << m[:cmd]
        return
      end
      raise ArgumentError, "Unknown syntax #{line}"
    end

  end
end
