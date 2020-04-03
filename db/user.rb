# frozen_string_literal: true

require 'bcrypt'
require 'sequel'
require_relative './db'
require_relative './utils'
require_relative '../lib/models'

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

  def get_user_by_email(email)
    u = connection[:user_account].first(email: email)
    if u.nil?
      u
    else
      Models::User.new(u.select { |e| Models::User.members.include? e })
    end
  end
end
