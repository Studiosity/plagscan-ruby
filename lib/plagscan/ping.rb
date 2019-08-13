# frozen_string_literal: true

#
# PlagScan module
#
module Plagscan
  #
  # PlagScan ping API
  #
  def self.ping
    Plagscan::Request.request('ping').is_a? Net::HTTPOK
  end
end
