# frozen_string_literal: true

require 'uri'
require 'openssl'
require 'net/http'

require 'json'

require 'plagscan/version'

require 'plagscan/error'
require 'plagscan/request'

# APIs
require 'plagscan/ping'
require 'plagscan/token'
require 'plagscan/documents'

#
# Basic configuration for PlagScan API
#
module Plagscan
  def self.api_base
    'https://api.plagscan.com/v3/'
  end
end
