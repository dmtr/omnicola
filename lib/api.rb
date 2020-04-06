# frozen_string_literal: true

require 'json'
require 'rack'
require 'rack/contrib'
require 'logger'
require 'dry/validation'
require_relative './usecase'

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

# Api methods implementation
module ApiMethods
  include UserUseCases

  def signin(request)
    contract = UserCreds.new
    res = contract.call(request.params)
    if res.errors.empty?
      t = get_token(res[:email], res[:password])
      { token: t }
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
    @logger.error(e.to_s + '\n' + e.backtrace.join("\n"))
    Rack::Response.new({ error: 'Server error' }.to_json, 500)
  end

  def response
    @logger.debug(@request.params)
    case { path: @request.path, method: @request.request_method }
    in path: '/api/signin', method: 'POST'
      make_json_reponse { |_| signin @request }
    else
      Rack::Response.new('Not Found', 404)
    end
  end
end
