# frozen_string_literal: true

require 'spec_helper'

describe Plagscan::Users do
  let(:user_response) do
    {
      internalID: '123456',
      deptID: '-1',
      title: '',
      username: 'test@example.com',
      firstname: 'Test',
      lastname: 'User',
      language: '0',
      email: 'test@example.com'
    }
  end

  describe '.list' do
    it 'calls to PlagScan user list API with token' do
      stub_request(:get, 'https://api.plagscan.com/v3/users?access_token=my-token').
        to_return(body: { data: [user_response] }.to_json, status: 200)

      result = described_class.list(access_token: 'my-token')

      expect(result).to eq [user_response]
    end

    it 'accepts start/limit optional parameters (filtered)' do
      stub_request(:get, 'https://api.plagscan.com/v3/users?access_token=my-token&start=3&limit=10').
        to_return(body: { data: [user_response] }.to_json, status: 200)

      result = described_class.list(access_token: 'my-token', start: 3, limit: 10, bad: 123)

      expect(result).to eq [user_response]
    end
  end

  describe '.get' do
    it 'calls to PlagScan user get API with token and user ID' do
      stub_request(:get, 'https://api.plagscan.com/v3/users/123456?access_token=my-token').
        to_return(body: { data: user_response }.to_json, status: 200)

      result = described_class.get(access_token: 'my-token', user_id: 123_456)

      expect(result).to eq user_response
    end
  end
end
