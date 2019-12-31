# frozen_string_literal: true

module Plagscan
  #
  # PlagScan users API
  #
  class Users
    #
    # User get REST API
    # @param [Number] start The start position of the list (optional)
    # @param [Number] limit The limit of results returned (optional)
    # @return [Array] containing array of data for Users
    #
    # For more details, see https://api.plagscan.com/v3docs/#api-User-ListUser
    #
    def self.list(access_token:, **options)
      list_props = options.delete_if { |k, _| !%i[start limit].include? k }

      Plagscan::Request.json_request(
        'users',
        access_token: access_token, body: list_props
      )&.[](:data)
    end

    #
    # User get REST API
    # @param [Number] user_id PlagScan user ID
    # @return [Hash] containing data from a User
    #
    # For more details, see https://api.plagscan.com/v3docs/#api-User-GetUser
    #
    def self.get(access_token:, user_id:)
      Plagscan::Request.json_request(
        "users/#{user_id}",
        access_token: access_token
      )&.[](:data)
    end
  end
end
