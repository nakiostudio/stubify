require 'stubify/io'
require 'sinatra/base'
require 'net/http'

module Stubify
  class Server < Sinatra::Base

    set :app_file, __FILE__
    set :run, true
    set :quiet, !Stubify.options.verbose

    if run?
      puts 'Launching Sinatra app...'
    end

    at_exit { Server.run! if $!.nil? && Server.run? }

    get '/*' do
      Server.log("Processing request GET: #{request.url}")
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    post '/*' do
      Server.log("Processing request POST: #{request.url}")

      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    delete '/*' do
      Server.log("Processing request DELETE: #{request.url}")
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    put '/*' do
      Server.log("Processing request PUT: #{request.url}")
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    def self.on_request(request)
      body = nil
      body = request.body.read unless request.body.nil?

      if IO.cached?(request, body)
        puts "Loading \"#{request.path}\" from cache"
        response_map = IO.read_from_disk(request, body)
        return response_map
      else
        puts "Requesting \"#{request.path}\""
        response = Server.forward(request, request.request_method, body)
        response_map = IO.write_on_disk(request, body, response)
        return response_map
      end
    end

    def self.log(message)
      if Stubify.options.verbose 
      	puts message
      end
    end

    def self.extractHeaders(request)
      extracted = Hash.new(0)

      request.env.each { |key, value|
        next unless value.is_a?(String)

        new_key = key.dup

        # Include all env variables supposed to be HTTP headers
        if new_key.include?('HTTP_')
          new_key.slice!('HTTP_')
          # Ignore HOST and VERSION headers
          next unless !['HOST', 'VERSION'].include?(new_key)
          extracted[new_key] = value
        end

        # Include all env variables supposed to be CONTENT headers
        if key.include?('CONTENT_')
          # Convert underscore into dash
          new_key = new_key.gsub('_', '-') unless !new_key.include?('_')
          extracted[new_key] = value
        end
      }
      extracted
    end

    def self.forward(request, method, body)

      Server.log("Forwarding...")
      Server.log("Building request to forward...")

      # Build url
      uri = URI(Stubify.options.host)
      uri.path = request.path
      uri.query = request.query_string

      Server.log("URI: #{uri}")

      # Create new request
      new_req = nil
      if method == 'DELETE'
        Server.log("METHOD: #{method}")
        new_req = Net::HTTP::Delete.new(uri)
        new_req.body = body
      elsif method == 'POST'
        Server.log("METHOD: #{method}")
        new_req = Net::HTTP::Post.new(uri)
        new_req.body = body
      elsif method == 'PUT'
        Server.log("METHOD: #{method}")
        new_req = Net::HTTP::Put.new(uri)
        new_req.body = body
      else
        Server.log("METHOD: #{GET}")
        new_req = Net::HTTP::Get.new(uri)
      end


      # Set headers
      Server.log("Headers:")

      Server.extractHeaders(request).each { |key, value|
        Server.log("     #{key} : #{value}")
        new_req[key] = value
      }

      Server.log("Performing request ... ")
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') {
          |http| http.request(new_req)
      }
      Server.log("Done!")

      return response
    end

  end
end



extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end
