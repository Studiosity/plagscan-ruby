# frozen_string_literal: true

module Plagscan
  class Error < StandardError; end
  class HTTPError < Error; end
  class InvalidMethodError < HTTPError; end
end
