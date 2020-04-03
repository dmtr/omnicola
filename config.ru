# frozen_string_literal: true

require 'api'

use Rack::Reloader, 0

use Rack::JSONBodyParser
use Rack::ContentType, 'application/json'

run Api
