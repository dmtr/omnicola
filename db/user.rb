# frozen_string_literal: true

require 'bcrypt'
require 'sequel'
require_relative './db'
require_relative './utils'

# user related database methods
module UserDataStore
  include Database
  include Utils
  # class User < Sequel::Model(:user_account); end

  def create_user(user, password)
    params = user.to_h .merge(pwd_hash: BCrypt::Password.create(password))
    begin
      u = connection[:user_account].insert(params)
      u
    rescue Sequel::DatabaseError => e
      log.error(e)
    end
  end
end
