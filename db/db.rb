# frozen_string_literal: true

require 'sequel'
require_relative './utils'

# Database related methods
module Database
  include Utils

  def connection
    @@connection ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
    log.debug @@connection.object_id
    @@connection
  end
end
