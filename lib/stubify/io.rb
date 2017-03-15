require 'fileutils'
require 'pathname'
require 'net/http'
require 'digest'
require 'json'

module Stubify
  class IO

    def self.write_on_disk(request, body, response)
      path = IO.path_from_request(request)
      file_name = IO.file_name_from_request(request, body)

      data = {
        'status_code': response.code,
        'content_type': response.content_type,
        'body': response.body.to_s
      }

      # Do not persist if path is whitelisted
      return data if Stubify.options.whitelisted.include?(request.path)

      FileUtils.mkdir_p(path)
      File.open(File.join(path, file_name), "wb") do |file|
        file.puts(data.to_json)
      end

      return data
    end

    def self.read_from_disk(request, body)
      path = IO.path_from_request(request)
      file_name = IO.file_name_from_request(request, body)
      file = File.read(File.join(path, file_name))
      return JSON.parse(file)
    end

    def self.cached?(request, body)
      # Do not load cache if path is whitelisted
      return false if Stubify.options.whitelisted.include?(request.path)

      # Otherwise check there is a cached payload
      path = IO.path_from_request(request)
      file_name = IO.file_name_from_request(request, body)
      return Pathname.new(File.join(path, file_name)).file?
    end

    def self.path_from_request(request)
      return File.join(Stubify.options.directory, request.path)
    end

    def self.file_name_from_request(request, body)
      file_name = request.request_method.dup
      file_name << request.query_string.dup unless request.query_string.nil?
      unless body.nil?
        file_name << Digest::SHA256.hexdigest(body.to_s)
      end
      file_name = "#{Digest::SHA256.hexdigest(file_name)}.json"
      return file_name
    end

  end
end
