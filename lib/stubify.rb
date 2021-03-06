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
      program :help, 'Author', 'Carlos Vidal <nakioparkour@gmail.com>'

      command :server do |c|
        c.syntax = 'server [options]'
        c.description = 'Runs a local environment that will forward the requests received to the host provided. Responses will be cached'
        c.option '--host STRING', String, 'Host the requests will be redirected to. i.e. https://easy-peasy.io'
        c.option '--port STRING', String, 'Port the local environment will listen to. Default is 4567'
        c.option '--directory DIR', String, 'Path where fixtures will be stored. i.e. fixtures/'
        c.option '--whitelist DIR', String, 'Path to the .yaml file with the whitelisted paths'
        c.option '--verbose', 'Increases the amount of information logged'
        c.action do |args, options|
          # Ensure host is set
          if options.host.nil?
            raise 'Host must be provided. Run help command for more details'
          end

          # Default options
          options.default \
            port: '4567',
            directory: 'fixtures',
            verbose: false,
            whitelisted: parse_whitelist(options.whitelist)

          # Set env variables
          ENV['PORT'] = options.port

          # Set options global attr
          Stubify.options = options

          # Launch Sinatra app
          require 'stubify/server'
        end
      end
      run!
    end

    def parse_whitelist(file_path)
      require 'yaml'
      return [] unless !file_path.nil? && Pathname.new(file_path).file?
      return YAML.load_file(file_path)
    end

  end
end
