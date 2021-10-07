# frozen_string_literal: true

module Polycon
  module Utils
    attr_accessor :dir

    def initialize
      self.dir = './.polycon'
    end

    def self.ensure_polycon_root_exists
      puts 'am ensuring the root exists'
    end
  end
end
