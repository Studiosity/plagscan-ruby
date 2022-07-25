# frozen_string_literal: true

require 'spec_helper'

describe Plagscan::Token do
  describe '.fetch' do
    subject(:fetch) { described_class.fetch client_id: '12345', client_secret: 'abcde' }

    it 'calls to PlagScan token API with credentials' do
      allow(Plagscan::Request).to(
        receive(:json_request).
          with('token', method: :post, body: { client_id: '12345', client_secret: 'abcde' }).
          and_return(access_token: 'your_token', expires_in: 3600)
      )
      expect(Plagscan::Request).to(
        receive(:json_request).
          with('token', method: :post, body: { client_id: '12345', client_secret: 'abcde' })
      )

      expect(fetch).to eq(access_token: 'your_token', expires_in: 3600)
    end
  end
end
