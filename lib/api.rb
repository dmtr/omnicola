# frozen_string_literal: true

require 'json'
require 'rack'
require 'rack/contrib'
require 'logger'
require 'dry/validation'

# Api methods implementation
module ApiMethods
  class UserCreds < Dry::Validation::Contract
    json do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email) do
      unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
        key.failure('has invalid format')
      end
    end
  end

  def signin(request)
    contract = UserCreds.new
    res = contract.call(request.params)
    if res.errors.empty?
      @logger.debug(res)
    else
      res.errors.to_h
    end
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
