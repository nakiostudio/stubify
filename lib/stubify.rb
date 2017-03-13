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
        c.option '--directory STRING', String, 'Path where fixtures will be stored. i.e. fixtures/'
        c.option '--host STRING', String, 'Host the requests will be redirected to. i.e. https://easy-peasy.io'
        c.action do |args, options|
          Stubify.options = options
          require 'stubify/server'
        end
      end
      run!
    end

  end
end
