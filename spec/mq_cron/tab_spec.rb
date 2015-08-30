require 'spec_helper'
require 'mq_cron/tab'

RSpec.describe MqCron::Tab do

  describe 'parsing' do
    describe 'RABBITMQ_ parameters' do
      it 'honors RABBITMQ_URL' do
        allow(ENV).to receive(:[]).with('RABBITMQ_URL').and_return('amqps://host')
        ct = MqCron::Tab.new("")
        expect(ct.connection).to include(host: 'host', scheme: 'amqps')
      end

      it 'parses RABBITMQ_URL' do
        ct = MqCron::Tab.new(<<-CRONTAB)
RABBITMQ_URL=amqps://server
        CRONTAB
        expect(ct.connection).to include(host: 'server', scheme: 'amqps')
      end

      describe 'sets RABBITMQ_ parameters' do
        it 'parses integers' do
          ct = MqCron::Tab.new(<<-CRONTAB)
RABBITMQ_HEARTBEAT=300
          CRONTAB
          expect(ct.connection).to include(heartbeat: 300)
        end

        it 'parses arrays' do
          ct = MqCron::Tab.new(<<-CRONTAB)
RABBITMQ_HOSTS=hosta hostb
          CRONTAB
          expect(ct.connection).to include(hosts: ['hosta', 'hostb'])
        end
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
