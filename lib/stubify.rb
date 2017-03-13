require 'commander'
require 'stubify/version'

module Stubify
  class << self

    include Commander::Methods

    attr_accessor :options

    def run
      program :name, 'stubify'
      program :version, Stubify::VERSION
      program :description, Stubify::DESCRIPTION

      command :server do |c|
        c.syntax = 'server'
        c.description = ''
        c.option '--directory STRING', String, 'Path where fixtures will be stored'
        c.action do |args, options|
          Stubify.options = options
          require 'stubify/server'
        end
      end
      run!
    end

  end
end
