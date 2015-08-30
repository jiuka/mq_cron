module MqCron
  class Tab
    attr_reader :env, :entry, :connection

    def initialize(crontab, options={})
      @crontab = crontab
      @options = options
      @env = {}
      @entry = {}
      @connection = {}
      if ENV['RABBITMQ_URL']
        @connection.merge! Bunny::Session.parse_uri(ENV['RABBITMQ_URL'])
      end

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
        if m[:key].start_with?('RABBITMQ_')
          if m[:key] == 'RABBITMQ_URL'
            @connection.merge! Bunny::Session.parse_uri(m[:value])
          else
            key = m[:key][9..-1].downcase.to_sym
            if /\A\d+\z/.match(m[:value])
              @connection[key] = m[:value].to_i
            elsif m[:value].include?(' ')
              @connection[key] = m[:value].split(' ')
            else
              @connection[key]= m[:value]
            end
          end
        else
          @env[m[:key].to_sym] = m[:value]
        end
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
