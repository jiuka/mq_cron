require 'spec_helper'

require 'mq_cron/routing_key_matcher'

RSpec.describe MqCron::RoutingKeyMatcher do

  subject { described_class.new(self.class.description) }

  describe 'routing.key' do
    it 'matches routing.key' do
      expect(subject.match?('routing.key')).to be_truthy
    end

    it 'does not match key.route' do
      expect(subject.match?('key.route')).to be_falsey
    end

    it 'matches routing-key' do
      expect(subject.match?('routing-key')).to be_falsey
    end
  end

  describe 'routing.key.#' do
    it 'matches routing.key' do
      expect(subject.match?('routing.key')).to be_truthy
    end

    it 'matches routing.key.subkey' do
      expect(subject.match?('routing.key.subkey')).to be_truthy
    end

    it 'does not match routing.key2' do
      expect(subject.match?('routing.key2')).to be_falsey
    end

    it 'does not match routing' do
      expect(subject.match?('routing')).to be_falsey
    end

    it 'does not match routing.routing.key' do
      expect(subject.match?('routing.routing.key')).to be_falsey
    end
  end

  describe '#.routing.key' do
    it 'matches routing.key' do
      expect(subject.match?('routing.key')).to be_truthy
    end
    
    it 'matches prefix.routing.key' do
      expect(subject.match?('prefix.routing.key')).to be_truthy
    end

    it 'does not match routing.key2' do
      expect(subject.match?('routing.key2')).to be_falsey
    end
  end

  describe 'routing.#.key' do
    it 'matches routing.key' do
      expect(subject.match?('routing.key')).to be_truthy
    end

    it 'matches routing.and.key' do
      expect(subject.match?('routing.and.key')).to be_truthy
    end
  end

  describe 'routing.key.*' do
    it 'matches routing.key.subkey' do
      expect(subject.match?('routing.key.subkey')).to be_truthy
    end

    it 'does not match routing.key' do
      expect(subject.match?('routing.key')).to be_falsey
    end

    it 'does not match routing.key.sub.key' do
      expect(subject.match?('routing.key.sub.key')).to be_falsey
    end
  end

  describe '*.routing.key' do
    it 'matches prefix.routing.key' do
      expect(subject.match?('prefix.routing.key')).to be_truthy
    end

    it 'does not match routing.key' do
      expect(subject.match?('routing.key')).to be_falsey
    end

    it 'matches pre.fix.routing.key' do
      expect(subject.match?('pre.fix.routing.key')).to be_falsey
    end
  end

  describe 'routing.*.key' do
    it 'matches routing.and.key' do
      expect(subject.match?('routing.and.key')).to be_truthy
    end

    it 'does not match routing.key' do
      expect(subject.match?('routing.key')).to be_falsey
    end

    it 'does not match routing.and.or.key' do
      expect(subject.match?('routing.iand.or.key')).to be_falsey
    end
  end

end
