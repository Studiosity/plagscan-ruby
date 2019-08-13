# frozen_string_literal: true

require 'uri'
require 'openssl'
require 'net/http'

module Plagscan
  #
  # PlagScan HTTP request service
  #
  class Request
    DEFAULT_REQUEST_OPTIONS = {
      method: :get,
      body: nil,
      headers: nil,
      ssl_verify_mode: OpenSSL::SSL::VERIFY_PEER,
      ssl_ca_file: nil
    }.freeze

    class << self
      def api_url(path = '')
        Plagscan.api_base + path
      end

      def request(path, options = {})
        options = DEFAULT_REQUEST_OPTIONS.merge(options)

        raise Plagscan::InvalidMethodError unless %i[get post].include? options[:method]

        http = create_http(options)
        req = create_request(path, options)
        http.start { http.request(req) }
      end

      private

      def create_http(options)
        uri = URI api_url
        http = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = options[:ssl_verify_mode]
          http.ca_file = options[:ssl_ca_file] if options[:ssl_ca_file]
        end

        http
      end

      def create_request(path, options)
        headers = extract_headers(options)
        body = options[:body]

        if options[:method] == :post
          req = Net::HTTP::Post.new(path, headers)
          add_body(req, body) if body
          req
        else
          uri = api_url path
          uri += '?' + body.map { |k, v| "#{k}=#{v}" }.join('&') if body
          Net::HTTP::Get.new(uri, headers)
        end
      end

      def extract_headers(options)
        headers = options[:headers]

        token = options.delete :token
        if token
          headers ||= {}

          headers['X-Auth-Token'] = token.auth_token
          headers['X-User-Id'] = token.user_id
        end

        return unless headers

        headers = Util.stringify_hash_keys headers
        headers.delete_if { |key, value| key.nil? || value.nil? }
      end

      def add_body(request, body)
        if body.is_a? Hash
          request.body = body.to_json
          request.content_type = 'application/json'
        else
          request.body = body.to_s
        end
      end
    end
  end
end
