# frozen_string_literal: true

#
# PlagScan ping API
#
module Plagscan
  #
  # ping REST API
  # @return [Boolean]
  #
  def self.ping
    Plagscan::Request.request('ping').is_a? Net::HTTPOK
  end
end
