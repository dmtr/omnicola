# frozen_string_literal: true

require 'rack'

# web api
class Api
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when '/' then Rack::Response.new('test!')
    else Rack::Response.new('Not Found', 404)
    end
  end
end
