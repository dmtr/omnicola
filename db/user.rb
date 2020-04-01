# frozen_string_literal: true

require 'bcrypt'
require 'sequel'
require 'logger'
require_relative './db'

logger = Logger.new(STDOUT)

# user related database methods
module UserDataStore
  include Database
  # class User < Sequel::Model(:user_account); end

  def create_user(user, password)
    params = user.to_h .merge(pwd_hash: BCrypt::Password.create(password))
    begin
      u = connection[:user_account].insert(params)
      u
    rescue Sequel::DatabaseError => e
      logger.error(e)
    end
  end
end
