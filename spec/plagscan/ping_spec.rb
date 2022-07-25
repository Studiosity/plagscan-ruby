# frozen_string_literal: true

require 'spec_helper'

describe Plagscan do # rubocop:disable RSpec/FilePath
  describe '.ping' do
    subject(:ping) { described_class.ping }

    let(:success_result) { Net::HTTPOK.new '1', 200, 'success' }
    let(:failure_result) { Net::HTTPBadRequest.new '1', 400, 'fails' }

    it 'returns success for a success result' do
      allow(Plagscan::Request).to receive(:request).with('ping').and_return success_result
      expect(Plagscan::Request).to receive(:request).with('ping')
      expect(ping).to be true
    end

    it 'returns failure for a failure result' do
      allow(Plagscan::Request).to receive(:request).with('ping').and_return failure_result
      expect(Plagscan::Request).to receive(:request).with('ping')
      expect(ping).to be false
    end
  end
end
