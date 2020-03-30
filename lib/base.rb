# frozen_string_literal: true

require 'rack'

# web api
module BaseWebApi
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end
end
