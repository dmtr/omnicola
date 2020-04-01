# frozen_string_literal: true

require 'sequel'

module Database
  @db = nil

  def connection
    if @db.nil?
      @db = Sequel.connect(ENV.fetch('DATABASE_URL'))
    end
    @db
  end
end
