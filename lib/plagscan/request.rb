# frozen_string_literal: true

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

      def user_agent
        "PlagScan-Ruby/#{Plagscan::VERSION}"
      end

      def request(path, options = {})
        options = DEFAULT_REQUEST_OPTIONS.merge(options)

        raise Plagscan::InvalidMethodError unless %i[get post].include? options[:method]

        http = create_http(options)
        req = create_request(path, options)
        http.start { http.request(req) }
      end

      def json_request(path, options = {})
        response = Plagscan::Request.request(path, options)

        unless response.is_a? Net::HTTPOK
          raise Plagscan::HTTPError, "Invalid http response code: #{response.code}"
        end

        JSON.parse response.body
      rescue JSON::ParserError
        raise Plagscan::JsonParseError, "PlagScan response parse error: #{response.body}"
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
        body = options[:body]
        headers = { 'User-Agent' => user_agent }
        uri = api_url path

        if options[:method] == :post
          req = Net::HTTP::Post.new(uri, headers)
          add_body(req, body) if body
          req
        else
          uri += '?' + body.map { |k, v| "#{k}=#{v}" }.join('&') if body
          Net::HTTP::Get.new(uri, headers)
        end
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
