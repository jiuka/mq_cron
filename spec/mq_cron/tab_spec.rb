require 'spec_helper'
require 'mq_cron/tab'

RSpec.describe MqCron::Tab do

  describe 'parsing' do
    describe 'rabbitmq url' do
      it 'has a default url' do
        ct = MqCron::Tab.new("")
        expect(ct.url).to eq('amqp://localhost')
      end

      it 'honors RABBITMQ_URL' do
        expect(ENV).to receive(:[]).with('RABBITMQ_URL').and_return('amqps://host')
        ct = MqCron::Tab.new("")
        expect(ct.url).to eq('amqps://host')
      end

      it 'sets it with RABBITMQ_URL' do
        ct = MqCron::Tab.new(<<-CRONTAB)
RABBITMQ_URL=amqps://server
        CRONTAB
        expect(ct.url).to eq('amqps://server')
      end
    end

    it 'rejects unknown lines' do
      expect {
      MqCron::Tab.new(<<-CRONTAB)
muell
      CRONTAB
      }.to raise_exception(ArgumentError)
    end

    it 'ignores comments' do
      expect {
        MqCron::Tab.new(<<-CRONTAB)
#comment
 #comment
   
        CRONTAB
      }.not_to raise_exception
    end

    it 'accepts envs' do
      ct = MqCron::Tab.new(<<-CRONTAB)
KEY="VALUE"
KEY2=VALUE2
      CRONTAB

      expect(ct.env).to include(:KEY => 'VALUE')
      expect(ct.env).to include(:KEY2 => 'VALUE2')
    end

    describe 'events' do
      it 'should accept known event' do
        ct = MqCron::Tab.new(<<-CRONTAB)
@connect /bin/true
        CRONTAB
  
        expect(ct.event).to include(:connect => ['/bin/true'])
      end
  
      it 'should reject unknown events' do
        expect {
          MqCron::Tab.new(<<-CRONTAB)
@unknown /bin/true
          CRONTAB
        }.to raise_exception(ArgumentError)
      end
    end
  
    describe 'parse messages' do
      it 'should parse message lines' do
        ct = MqCron::Tab.new(<<-CRONTAB)
exchange.name routing.key.# /bin/command
exchange.name routing.key2.* /bin/command
        CRONTAB
  
        expect(ct.entry).to include(
          'exchange.name' => {
            'routing.key.#' => ['/bin/command'],
            'routing.key2.*' => ['/bin/command'],
          }
        )
      end
    end
  end
end
