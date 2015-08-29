require 'spec_helper'

require 'mq_cron/command_runner'

RSpec.describe MqCron::CommandRunner do

  let(:command) { '/bin/true' }
  let(:env) { [] }

  describe '#run' do
    it 'forks a new subprocess' do
      expect(Process).to receive(:fork)

      MqCron::CommandRunner.run(command, env)
    end

    it 'starts process' do
      expect(Process).to receive(:fork) do |&block|
        expect(Open3).to receive(:capture2e).with(env, command).and_return(['',0])
        block.call
      end
      MqCron::CommandRunner.run(command, env)
    end
  end

end
