require 'commander'

module Stubify
  class << self

    include Commander::Methods

    def run
      program :name, 'Foo Bar'
      program :version, '1.0.0'
      program :description, 'Stupid command that prints foo or bar.'

      command :foo do |c|
        c.syntax = 'foobar foo'
        c.description = 'Displays foo'
        c.action do |args, options|
          puts 'foo'
        end
      end

      run!
    end

    Stubify.new.run if $0 == __FILE__

  end
end
