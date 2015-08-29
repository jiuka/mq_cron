require 'optparse'

require 'mq_cron/version'

module MqCron
  class Cli
    attr_reader :options

    def initialize(arguments)
      @arguments = arguments
      @options = {}

      parse
      validate
    end

    private

    def parse
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} [options]"

        opts.on('-v', '--version', 'Show version') do
          puts "ResolverFlusher #{MqCron::VERSION}"
          exit
        end

        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on('-c', '--crontab FILENAME', String, 'Path to the crontab file.') do |filename|
          options[:crontab] = File.absolute_path filename
        end

        opts.on('-l', '--logfile FILENAME', String, 'Path to the logfile.') do |filename|
          options[:logfile] = File.absolute_path filename
        end

        opts.on('-p', '--piddir PIDDIR', String, 'Path to the pidfile.') do |filename|
          options[:piddir] = File.absolute_path filename
        end

        opts.on('-d', '--debug', 'Run in foreground') do |debug|
          options[:debug] = debug
        end
      end.parse!(@arguments)
    end

    def validate
      unless options[:crontab]
        puts '--crontab is a mandatory option.'
        exit 1
      end
      unless File.file?(options[:crontab]) and File.readable?(options[:crontab])
        puts "File '#{options[:crontab]}' is not readable"
        exit 1
      end
    end
  end
end
