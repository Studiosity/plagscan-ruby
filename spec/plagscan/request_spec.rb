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
    shared_examples 'inline request type' do |method:|
      it 'calls to API for requested URL' do
        stub_request(method, 'https://api.plagscan.com/v3/my/path').
          to_return(body: 'request worked!')

        response = described_class.request 'my/path', method: method

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'request worked!'
      end

      it 'passes through request parameters in the path' do
        stub_request(method, 'https://api.plagscan.com/v3/with/params?test=parameter').
          to_return(body: 'yep, it had parameters')

        response =
          described_class.request 'with/params', method: method, body: { test: 'parameter' }

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through gem user-agent' do
        stub_request(method, 'https://api.plagscan.com/v3/with/useragent').
          with(headers: { 'User-Agent' => "PlagScan-Ruby/#{Plagscan::VERSION}" }).
          to_return(body: 'yep, it had a user agent')

        response = described_class.request 'with/useragent', method: method

        expect(response.body).to eq 'yep, it had a user agent'
      end

      it 'returns error response types' do
        stub_request(method, 'https://api.plagscan.com/v3/not/here').
          to_return(body: 'path not found', status: 404)

        response = described_class.request 'not/here', method: method

        expect(response).to be_a Net::HTTPNotFound
        expect(response.body).to eq 'path not found'
      end
    end

    shared_examples 'body request type' do |method:|
      it 'calls to API for requested URL' do
        stub_request(method, 'https://api.plagscan.com/v3/post/path').
          to_return(body: 'request worked!')

        response = described_class.request 'post/path', method: method

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'request worked!'
      end

      it 'passes through request parameters in the body' do
        stub_request(method, 'https://api.plagscan.com/v3/with/params').
          with(body: { test: 'parameter' }, headers: { 'Content-Type' => 'application/json' }).
          to_return(body: 'yep, it had parameters')

        response =
          described_class.request 'with/params', method: method, body: { test: 'parameter' }

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through string type body' do
        stub_request(method, 'https://api.plagscan.com/v3/with/params').
          with(body: 'not so complex').
          to_return(body: 'yep, it had parameters')

        response = described_class.request 'with/params', method: method, body: 'not so complex'

        expect(response).to be_a Net::HTTPOK
        expect(response.body).to eq 'yep, it had parameters'
      end

      it 'passes through gem user-agent' do
        stub_request(method, 'https://api.plagscan.com/v3/with/useragent').
          with(headers: { 'User-Agent' => "PlagScan-Ruby/#{Plagscan::VERSION}" }).
          to_return(body: 'yep, it had a user agent')

        response = described_class.request 'with/useragent', method: method

        expect(response.body).to eq 'yep, it had a user agent'
      end

      it 'uses multi-part form submission if any of the params are File type' do
        stub_request(method, 'https://api.plagscan.com/v3/with/file/params').
          with(headers: { 'Content-Type' => 'multipart/form-data' }).
          to_return(body: 'multipart looks good')

        file = File.open('README.md')
        response =
          described_class.request 'with/file/params', method: method, body: { my_file: file }

        expect(response.body).to eq 'multipart looks good'
      end
    end

    it 'defaults to GET request if no method is specified' do
      stub_request(:get, 'https://api.plagscan.com/v3/my/path').
        to_return(body: 'request worked!')

      response = described_class.request 'my/path'

      expect(response).to be_a Net::HTTPOK
      expect(response.body).to eq 'request worked!'
    end

    it_behaves_like 'inline request type', method: :get
    it_behaves_like 'inline request type', method: :head
    it_behaves_like 'inline request type', method: :delete
    it_behaves_like 'inline request type', method: :options
    it_behaves_like 'inline request type', method: :trace

    it_behaves_like 'body request type', method: :post
    it_behaves_like 'body request type', method: :put
    it_behaves_like 'body request type', method: :patch

    it 'raises InvalidMethodError if an invalid method provided' do
      expect do
        described_class.request 'invalid', method: :invalid
      end.to raise_error Plagscan::InvalidMethodError, '`invalid` is not a valid HTTP method'
    end
  end

  describe '.json_request' do
    it 'allows just path to be passed through to `request`' do
      stub_request(:get, 'https://api.plagscan.com/v3/my/path').to_return(body: '{"key":"abc"}')
      if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.8.0')
        expect(described_class).to receive(:request).with('my/path').and_call_original
      else
        expect(described_class).to receive(:request).with('my/path', {}).and_call_original
      end
      described_class.json_request 'my/path'
    end

    it 'allows options to be passed through to `request`' do
      stub_request(:get, 'https://api.plagscan.com/v3/my/path?my=option').
        to_return(body: '{"key":"abc"}')
      expect(described_class).to(
        receive(:request).
          with('my/path', body: { my: 'option' }).
          and_call_original
      )

      described_class.json_request 'my/path', body: { my: 'option' }
    end

    it 'returns the parsed result if the response is success' do
      stub_request(:get, 'https://api.plagscan.com/v3/success').
        to_return(body: '{"key1":"abc","key2":"def"}')

      result = described_class.json_request 'success'

      expect(result).to eq(key1: 'abc', key2: 'def')
    end

    it 'raises a HTTPError if the response is not success' do
      stub_request(:get, 'https://api.plagscan.com/v3/bad_request').
        to_return(body: 'No can do buddy', status: 400)

      expect do
        described_class.json_request 'bad_request'
      end.to raise_error Plagscan::HTTPError, 'Invalid http response: 400 - No can do buddy'
    end

    it 'allows asserting the exact response type' do
      stub_request(:get, 'https://api.plagscan.com/v3/no_content').
        to_return(body: '{"key":"abc"}')

      expect do
        described_class.json_request 'no_content', expected_result: Net::HTTPNoContent
      end.to raise_error Plagscan::HTTPError, 'Invalid http response: 200 - {"key":"abc"}'
    end

    it 'raises a JsonParseError if the response is malformed' do
      stub_request(:get, 'https://api.plagscan.com/v3/malformed').
        to_return(body: 'Totes invalid')

      expect do
        described_class.json_request 'malformed'
      end.to raise_error Plagscan::JsonParseError, 'PlagScan response parse error: Totes invalid'
    end
  end
end
