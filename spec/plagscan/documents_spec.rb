# frozen_string_literal: true

require 'spec_helper'

describe Plagscan::Documents do
  describe '.create' do
    it 'calls to PlagScan document create API with token and basic text parameter' do
      expect(Plagscan::Request).to(
        receive(:json_request).
          with(
            'documents',
            method: :post, access_token: 'my-token', expected_result: Net::HTTPCreated,
            body: { textdata: 'my excellent document' }
          ).
          and_return(id: 1_536_238, Location: 'http://example.com/1536238')
      )

      result = described_class.create(access_token: 'my-token', text: 'my excellent document')

      expect(result).to eq(id: 1_536_238, Location: 'http://example.com/1536238')
    end

    it 'calls to PlagScan document create API with token and basic file parameter' do
      Tempfile.open('foo') do |file|
        expect(Plagscan::Request).to(
          receive(:json_request).
            with(
              'documents',
              method: :post, access_token: 'my-token', expected_result: Net::HTTPCreated,
              body: { fileUpload: file }
            ).
            and_return(id: 1_536_238, Location: 'http://example.com/1536238')
        )

        result = described_class.create(access_token: 'my-token', file: file)

        expect(result).to eq(id: 1_536_238, Location: 'http://example.com/1536238')
      end
    end

    it 'accepts optional parameters (filtered)' do
      expect(Plagscan::Request).to(
        receive(:json_request).
          with(
            'documents',
            method: :post, access_token: 'my-token', expected_result: Net::HTTPCreated,
            body: { textdata: 'my excellent document', userID: 3940,
                    textname: 'MyFile.docx', toRepository: true, saveOrig: false }
          ).
          and_return(id: 1_536_238, Location: 'http://example.com/1536238')
      )

      result =
        described_class.create(
          access_token: 'my-token', text: 'my excellent document', userID: 3940,
          textname: 'MyFile.docx', toRepository: true, saveOrig: false, unwanted: 'noope'
        )

      expect(result).to eq(id: 1_536_238, Location: 'http://example.com/1536238')
    end
  end

  describe '.check' do
    it 'calls to PlagScan document check API with token and document ID' do
      stub_request(:put, 'https://api.plagscan.com/v3/documents/189/check?access_token=my-token').
        to_return(status: 204)

      result = described_class.check(access_token: 'my-token', document_id: 189)

      expect(result).to be_nil
    end

    it 'raises a DocumentError if the result was failure' do
      stub_request(:put, 'https://api.plagscan.com/v3/documents/189/check?access_token=my-token').
        to_return(body: '{"error":{"message":"no good"}}', status: 404)

      expect do
        described_class.check(access_token: 'my-token', document_id: 189)
      end.to raise_error Plagscan::DocumentError, 'no good'
    end

    it 'handles invalid failure response body' do
      stub_request(:put, 'https://api.plagscan.com/v3/documents/189/check?access_token=my-token').
        to_return(body: 'Fails', status: 401)

      expect do
        described_class.check(access_token: 'my-token', document_id: 189)
      end.to raise_error Plagscan::DocumentError, 'Fails'
    end
  end

  describe '.retrieve' do
    it 'calls to PlagScan document retrieve API with token, document ID and mode' do
      expect(Plagscan::Request).to(
        receive(:json_request).
          with(
            'documents/189/retrieve',
            access_token: 'my-token', body: { mode: 2 }
          ).
          and_return(reportData: '<xml>content</xml>')
      )

      result = described_class.retrieve(access_token: 'my-token', document_id: 189, mode: 2)

      expect(result).to eq(reportData: '<xml>content</xml>')
    end

    it 'includes userID if specified' do
      expect(Plagscan::Request).to(
        receive(:json_request).
          with(
            'documents/189/retrieve',
            access_token: 'my-token', body: { mode: 2, userID: 57 }
          ).
          and_return(reportData: '<xml>content</xml>')
      )

      result =
        described_class.retrieve(access_token: 'my-token', document_id: 189, mode: 2, user_id: 57)

      expect(result).to eq(reportData: '<xml>content</xml>')
    end
  end
end
