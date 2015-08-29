require 'daemons'

require 'mq_cron/logger'
require 'mq_cron/tab'
require 'mq_cron/mq'
require 'mq_cron/routing_key_matcher'
require 'mq_cron/command_runner'

module MqCron
  class Daemon
    attr_reader :logger

    def initialize(options={})
      @options = options
    end

    def run
      Daemons.daemonize(
        app_name: 'mqcron',
        ontop: @options[:debug],
        backtrace: @options[:debug],
        log_output: false,
        dir_mode: :normal,
        dir: @options[:piddir])

      setup_logger

      logger.info "MqCron v#{MqCron::VERSION} starts up."

      crontab.entry.each do |exchange, entry|
        entry.each do |routing_key, command|
          mq.bind(exchange, routing_key)
        end
      end

      trap('SIGINT') { throw :end }
      trap('SIGTERM') { throw :end }
      catch :end do
        loop do
          sleep 60
        end
      end

      logger.info "MqCron shuts down."
      mq.close
    end

    def setup_logger
      unless @options[:debug]
        if @options[:logfile]
          MqCron::Logger.instance.logfile = @options[:logfile]
        else
          MqCron::Logger.instance.syslog
        end
      end
      @logger = MqCron::Logger.instance
    end

    def mq
      @mq ||= MqCron::Mq.new crontab.url, method(:receive)
    end

    def crontab
      @crontab ||= MqCron::Tab.new File.read(@options[:crontab])
    end

    def receive(delivery_info, metadata, payload)
      logger.debug "MqCron::Daemon#receive #{delivery_info}, #{metadata}, #{payload}"
      
      begin
        command_env = crontab.env.clone
        delivery_info.each do |key, value|
          command_env["MESSAGE_#{key.to_s.upcase}"] = value.to_s
        end
        metadata.each do |key, value|
          command_env["METADATA_#{key.to_s.upcase}"] = value.to_s
        end

        crontab.entry[delivery_info[:exchange]].each do |routing_key, commands|
          if MqCron::RoutingKeyMatcher.new(routing_key).match? delivery_info[:routing_key]
            commands.each do |command|
              MqCron::CommandRunner.run(command, command_env)
            end
          end
        end
      rescue Exception => e
        logger.error e.message
        e.backtrace.map { |line| logger.info line }
      end
    end

  end
end
