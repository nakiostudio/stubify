require 'stubify/io'
require 'sinatra/base'
require 'net/http'

module Stubify
  class Server < Sinatra::Base

    set :app_file, __FILE__
    set :run, Proc.new { true }

    if run?
      puts 'Launching Sinatra app...'
    end

    at_exit { Server.run! if $!.nil? && Server.run? }

    get // do
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    post // do
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    delete // do
      response = Server.on_request(request)
      status response['status_code']
      return response[:body] unless response[:body].nil?
      return response['body'] unless response['body'].nil?
    end

    put // do
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

    def self.forward(request, method, body)
      # Build url
      uri = URI(Stubify.options.host)
      uri.path = request.path
      uri.query = request.query_string

      # Create new request
      new_req = nil
      if method == 'DELETE'
        new_req = Net::HTTP::Delete.new(uri)
        new_req.body = body
      elsif method == 'POST'
        new_req = Net::HTTP::Post.new(uri)
        new_req.body = body
      elsif method == 'PUT'
        new_req = Net::HTTP::Put.new(uri)
        new_req.body = body
      else
        new_req = Net::HTTP::Get.new(uri)
      end

      # Set headers
      request.env.each do |key, value|
        if key.include?('HTTP_')
          new_key = key.dup
          new_key.slice!('HTTP_')
          new_req[new_key] = value unless ['HOST', 'VERSION'].include?(new_key)
        end
      end

      # Perform request
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(new_req)
      end

      return response
    end

  end
end

extend Sinatra::Delegator

class Rack::Builder
  include Sinatra::Delegator
end
