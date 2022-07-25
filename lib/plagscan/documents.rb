# frozen_string_literal: true

module Plagscan
  #
  # PlagScan documents API
  #
  class Documents
    #
    # Document create REST API
    # @param [String] access_token Access token from Token.fetch
    # @param [File] file Document file
    # @param [String] text Text from a document in plain text
    # @param [named options] userID, textname, toRepository, saveOrig
    # @return [Hash] containing document ID and URI location for created resource
    #
    # Note. you should provide fileUpload OR textdata
    # For more details, see https://api.plagscan.com/v3docs/#api-Document-SubmitDocument
    #
    def self.create(access_token:, file: nil, text: nil, **options)
      raise 'must specify file or text' if file.nil? && text.nil?

      create_props = options.delete_if do |k, _|
        !%i[userID textname toRepository saveOrig].include? k
      end

      Plagscan::Request.json_request(
        'documents',
        method: :post, access_token: access_token, expected_result: Net::HTTPCreated,
        body: create_props.merge(file ? { fileUpload: file } : { textdata: text }),
        read_timeout: 120
      )
    end

    #
    # Document create REST API
    # @param [String] access_token Access token from Token.fetch
    # @param [Integer] document_id Document ID as returned from create action
    # @return [Null]
    # @raise [DocumentError] Various reasons generally based around invalid document state.
    #
    # For more details, see https://api.plagscan.com/v3docs/#api-Document-CheckDocument
    #
    def self.check(access_token:, document_id:)
      response =
        Plagscan::Request.request(
          "documents/#{document_id}/check",
          method: :put, access_token: access_token
        )

      return if response.is_a? Net::HTTPNoContent

      error_message =
        begin
          JSON.parse(response.body)&.dig('error', 'message')
        rescue JSON::ParserError
          nil
        end
      raise DocumentError, error_message || response.body
    end

    #
    # Document retrieve REST API
    # @param [String] access_token Access token from Token.fetch
    # @param [Integer] document_id Document ID as returned from create action
    # @param [Integer] mode The retrieve mode of the report
    # @param [Integer] user_id Identify the user who is accessing to the report
    #                          (Only mandatory for mode 10). If not set it will get the user
    #                          ID associated with the access token or the organization admin ID.
    # @return [Hash] Various different values depending on the mode specified
    #
    # For more details, see https://api.plagscan.com/v3docs/#api-Document-RetrieveDocumentReport
    #
    def self.retrieve(access_token:, document_id:, mode:, user_id: nil)
      params = { mode: mode }
      params[:userID] = user_id if user_id

      Plagscan::Request.json_request(
        "documents/#{document_id}/retrieve",
        access_token: access_token, body: params
      )
    end
  end
end
