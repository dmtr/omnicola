# frozen_string_literal: true

require 'json'
require 'rack'
require 'rack/contrib'
require 'logger'

# Api methods implementation
module ApiMethods
  def signin(request)
    { token: 'test' }
  end
end

# web api
class Api
  include ApiMethods

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @logger = Logger.new(STDOUT)
  end

  def make_json_reponse(&block)
    r = block.call
    Rack::Response.new(r.to_json)
  rescue StandardError => e
    @logger.error('Got Error ' + e.to_s)
    Rack::Response.new({ error: 'Server error' }.to_json, 500)
  end

  def response
    @logger.debug(@request.params)
    case @request.path
    when '/api/signin'
      make_json_reponse { |_| signin @request }
    else
      Rack::Response.new('Not Found', 404)
    end
  end
end
