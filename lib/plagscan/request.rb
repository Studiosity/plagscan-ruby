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

      def request(path, **options)
        options = DEFAULT_REQUEST_OPTIONS.merge(options)
        http = create_http(options)
        req = create_request(path, options)
        http.start { http.request(req) }
      end

      def json_request(path, **options)
        response = Plagscan::Request.request(path, **options)

        unless response.is_a?(options[:expected_result] || Net::HTTPSuccess)
          raise Plagscan::HTTPError, "Invalid http response: #{response.code} - #{response.body}"
        end

        JSON.parse response.body, symbolize_names: true
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
        headers = { 'User-Agent' => user_agent }
        uri = api_url path

        if %i[post put patch].include? options[:method]
          body_request uri, headers, options
        else
          uri_request uri, headers, options
        end
      end

      def body_request(uri, headers, options)
        uri += '?access_token=' + options[:access_token] if options[:access_token]
        req = http_method(options).new(uri, headers)
        add_body(req, options[:body]) if options[:body]
        req
      end

      def uri_request(uri, headers, options)
        body = options[:body] || {}
        body[:access_token] = options[:access_token] if options[:access_token]
        uri += '?' + body.map { |k, v| "#{k}=#{v}" }.join('&') unless body.empty?
        http_method(options).new(uri, headers)
      end

      def add_body(request, body)
        if body.is_a? Hash
          if body.any? { |_, v| v.is_a? File }
            encoded_body = body.map { |k, v| [k.to_s, v.is_a?(File) ? v : v.to_s] }
            request.set_form encoded_body, 'multipart/form-data'
          else
            request.body = body.to_json
            request.content_type = 'application/json'
          end
        else
          request.body = body.to_s
        end
      end

      def http_method(options)
        method = options[:method].to_s.downcase
        method = method[0].upcase.concat(method[1..-1])
        Net::HTTP.const_get(method)
      rescue NameError
        raise Plagscan::InvalidMethodError, "`#{options[:method]}` is not a valid HTTP method"
      end
    end
  end
end
