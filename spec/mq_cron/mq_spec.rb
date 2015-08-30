require 'spec_helper'

require 'mq_cron/mq'

RSpec.describe MqCron::Mq do

  let(:settings) { {} }
  let(:callback) { Proc.new {|delivery_info, properties, payload| true } }
  let(:exchange) { 'exchange' }
  let(:routing_key) { 'routin.key.#' }

  let(:bunny) { class_double('Bunny') }
  let(:connection) { 'Bunny::Connection' }
  let(:channel) { 'Bunny::Channel' }
  let(:queue) { 'Bunny::Queue' }
  subject { described_class.new(settings, callback) }

  before(:each) do
    allow(Bunny).to receive(:new).with(settings).and_return(connection)
    allow(connection).to receive(:start).and_return(connection)
    allow(connection).to receive(:create_channel).and_return(channel)
    allow(connection).to receive(:exchange_exists?).and_return(true)
    allow(channel).to receive(:queue).and_return(queue)
    allow(queue).to receive(:bind).and_return(queue)
    allow(queue).to receive(:subscribe).and_return(queue)
  end

  describe '.initialize' do
    it 'sets the settings' do
      expect(subject.settings).to eq(settings)
    end

    it 'setup the callback' do
      expect(subject.callback).to eq(callback)
    end
  end

  describe '.connection' do
    it 'connects to bunny' do
      expect(Bunny).to receive(:new).with(settings).and_return(connection)
      subject.connection
    end

    it 'reuse the connection' do
      expect(Bunny).to receive(:new).with(settings).and_return(connection)
      subject.connection
      subject.connection
    end
  end

  describe '.channel' do
    it 'opens a channel' do
      expect(connection).to receive(:create_channel)
      subject.channel
    end

    it 'reuse the channel' do
      expect(connection).to receive(:create_channel)

      subject.channel
      subject.channel
    end
  end

  describe '.queue' do
    it 'creates a exclusive queue' do
      expect(channel).to receive(:queue).with(subject.send(:queue_name), :exclusive => true).and_return(queue)

      subject.queue
    end

    it 'reuse the queue' do
      expect(channel).to receive(:queue).with(subject.send(:queue_name), :exclusive => true).and_return(queue)

      subject.queue
      subject.queue
    end

    it 'setup the callback' do
      expect(queue).to receive(:subscribe)

      subject.queue
    end
  end

  describe '.bind' do
    it 'binds out queue to the named exchange' do
      expect(queue).to receive(:bind).with(exchange, :routing_key => routing_key).and_return(queue)

      subject.bind(exchange, routing_key)
    end
  end

  describe '.close' do
    it 'closes the connection' do
      expect(connection).to receive(:close)

      subject.close
    end
  end

  describe '.queue_name' do
    it 'returns a unique queue name' do
      expect(subject.send(:queue_name)).to eq("mqcron-#{Socket.gethostname}-#{Process.pid}")
    end
  end

end
