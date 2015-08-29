require 'open3'

require 'mq_cron/logger'

module MqCron
  class CommandRunner

    def self.run(command, env)
      Process.fork do
        logger = MqCron::Logger.instance
        logger.info "CMD (#{command})"
        out, status = Open3.capture2e(env, command)
        unless out.empty?
          logger.info "OUT (#{out})"
        end
      end
    end
  end
end
