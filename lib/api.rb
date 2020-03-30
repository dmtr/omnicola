# frozen_string_literal: true

require 'rack'
require 'base'

# web api
class Api
  include BaseWebApi

  def response
    case @request.path
    when '/' then Rack::Response.new('test!!!')
    else Rack::Response.new('Not Found', 404)
    end
  end
end
