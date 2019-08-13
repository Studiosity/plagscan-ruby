# frozen_string_literal: true

module Plagscan
  #
  # PlagScan access token API
  #
  class Token
    #
    # token REST API
    # @param [String] client_id your organisation ID
    # @param [String] client_secret the API key from https://www.plagscan.com/apisetup
    # @return [Hash] containing access_token and expires_in
    #
    def self.fetch(client_id:, client_secret:)
      Plagscan::Request.json_request(
        'token',
        method: :post, body: { client_id: client_id, client_secret: client_secret }
      )
    end
  end
end
