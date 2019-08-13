# frozen_string_literal: true

require 'spec_helper'

describe Plagscan do
  describe '.ping' do
    subject(:ping) { described_class.ping }

    let(:success_result) { Net::HTTPOK.new '1', 200, 'success' }
    let(:failure_result) { Net::HTTPBadRequest.new '1', 400, 'fails' }

    it 'returns success for a success result' do
      expect(Plagscan::Request).to receive(:request).with('ping').and_return success_result
      expect(ping).to eq true
    end

    it 'returns failure for a failure result' do
      expect(Plagscan::Request).to receive(:request).with('ping').and_return failure_result
      expect(ping).to eq false
    end
  end
end
