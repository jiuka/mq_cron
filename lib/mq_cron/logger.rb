require 'logger'
require 'singleton'

module MqCron
  class Logger
    include Singleton

    def logfile=(file)
      @logger = ::Logger.new file
    end

    def syslog
      require 'syslog/logger'
      @logger = Syslog::Logger.new 'mqcron'
    end

    def logger
      @logger ||= ::Logger.new STDOUT
    end

    def debug(message)
      logger.debug(message)
    end

    def error(message)
      logger.error(message)
    end

    def fatal(message)
      logger.fatal(message)
    end

    def info(message)
      logger.info(message)
    end

    def warn(message)
      logger.warn(message)
    end

  end
end
