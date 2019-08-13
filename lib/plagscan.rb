# frozen_string_literal: true

require 'plagscan/version'

require 'plagscan/error'
require 'plagscan/request'

# APIs
require 'plagscan/ping'

#
# Basic configuration for PlagScan API
#
module Plagscan
  def self.api_base
    'https://api.plagscan.com/v3/'
  end
end
