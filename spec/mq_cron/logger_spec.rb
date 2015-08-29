require 'spec_helper'

require 'mq_cron/logger'

RSpec.describe MqCron::Logger do

  subject { described_class.instance }
  let(:message) { 'MESSAGE' }

  before(:each) do
    Singleton.__init__(described_class)
  end

  describe 'singleton' do
    it 'does not allow create instances with new' do
      expect {
        MqCron::Logger.new
      }.to raise_exception(NoMethodError)
    end

    it 'returns the same instance for all .instance calls' do
      first = MqCron::Logger.instance
      second = MqCron::Logger.instance
      expect(first).to eq(second)
    end
  end

  describe '.logfile=' do
    it 'changes the logger' do
      expect {
        subject.logfile = STDOUT
      }.to change(subject, :logger)
    end
  end

  describe '.syslog' do
    it 'changes the logger' do
      expect {
        subject.syslog
      }.to change(subject, :logger)
    end

    it 'creates a new Syslog::Logger' do
      subject.syslog
      expect(subject.logger).to be_a_instance_of(Syslog::Logger)
    end
  end

  describe '.debug' do
    it 'calls its loggers debug' do
      expect(subject.logger).to receive(:debug).with(message)
      subject.debug(message)
    end
  end

  describe '.error' do
    it 'calls its loggers error' do
      expect(subject.logger).to receive(:error).with(message)
      subject.error(message)
    end
  end

  describe '.fatal' do
    it 'calls its loggers fatal' do
      expect(subject.logger).to receive(:fatal).with(message)
      subject.fatal(message)
    end
  end

  describe '.info' do
    it 'calls its loggers info' do
      expect(subject.logger).to receive(:info).with(message)
      subject.info(message)
    end
  end

  describe '.warn' do
    it 'calls its loggers warn' do
      expect(subject.logger).to receive(:warn).with(message)
      subject.warn(message)
    end
  end

end
