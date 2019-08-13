# frozen_string_literal: true

require 'spec_helper'

describe Plagscan::Request do
  describe '.api_url' do
    subject(:api_url) { described_class.api_url }

    it { is_expected.to eq 'https://api.plagscan.com/v3/' }

    context 'when specifying a path' do
      subject(:api_url) { described_class.api_url 'my/path' }

      it { is_expected.to eq 'https://api.plagscan.com/v3/my/path' }
    end
  end

  describe '.user_agent' do
    subject(:user_agent) { described_class.user_agent }

    it { is_expected.to eq "PlagScan-Ruby/#{Plagscan::VERSION}" }
  end

  describe '.request' do
    context 'with GET method' do
      it 'calls to API for requested URL' do
        stub_request(:get, 'https://api.plagscan.com/v3/my/path').
          to_return(body: 'request worked!')

        response = described_class.request 'my/path'

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'request worked!'
      end

      it 'passes through request parameters in the path' do
        stub_request(:get, 'https://api.plagscan.com/v3/with/params?test=parameter').
          to_return(body: 'yep, it had parameters')

        response = described_class.request('with/params', body: { test: 'parameter' })

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through gem user-agent' do
        stub_request(:get, 'https://api.plagscan.com/v3/with/useragent').
          with(headers: { 'User-Agent' => "PlagScan-Ruby/#{Plagscan::VERSION}" }).
          to_return(body: 'yep, it had a user agent')

        response = described_class.request('with/useragent')

        expect(response.body).to eq 'yep, it had a user agent'
      end

      it 'returns error response types' do
        stub_request(:get, 'https://api.plagscan.com/v3/not/here').
          to_return(body: 'path not found', status: 404)

        response = described_class.request('not/here')

        expect(response).to be_a Net::HTTPNotFound
        expect(response.body).to eq 'path not found'
      end
    end

    context 'with POST method' do
      it 'calls to API for requested URL' do
        stub_request(:post, 'https://api.plagscan.com/v3/post/path').
          to_return(body: 'request worked!')

        response = described_class.request 'post/path', method: :post

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'request worked!'
      end

      it 'passes through request parameters in the body' do
        stub_request(:post, 'https://api.plagscan.com/v3/with/params').
          with(body: { test: 'parameter' }, headers: { 'Content-Type' => 'application/json' }).
          to_return(body: 'yep, it had parameters')

        response =
          described_class.request(
            'with/params', method: :post, body: { test: 'parameter' }
          )

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through string type body' do
        stub_request(:post, 'https://api.plagscan.com/v3/with/params').
          with(body: 'not so complex').
          to_return(body: 'yep, it had parameters')

        response = described_class.request('with/params', method: :post, body: 'not so complex')

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through gem user-agent' do
        stub_request(:post, 'https://api.plagscan.com/v3/with/useragent').
          with(headers: { 'User-Agent' => "PlagScan-Ruby/#{Plagscan::VERSION}" }).
          to_return(body: 'yep, it had a user agent')

        response = described_class.request('with/useragent', method: :post)

        expect(response.body).to eq 'yep, it had a user agent'
      end
    end

    shared_examples_for 'raises InvalidMethodError for' do |method:|
      it do
        expect do
          described_class.request('invalid/method', method: method)
        end.to raise_error Plagscan::InvalidMethodError
      end
    end

    it_behaves_like 'raises InvalidMethodError for', method: :head
    it_behaves_like 'raises InvalidMethodError for', method: :put
    it_behaves_like 'raises InvalidMethodError for', method: :delete
    it_behaves_like 'raises InvalidMethodError for', method: :connect
    it_behaves_like 'raises InvalidMethodError for', method: :options
    it_behaves_like 'raises InvalidMethodError for', method: :trace
    it_behaves_like 'raises InvalidMethodError for', method: :patch
  end
end
