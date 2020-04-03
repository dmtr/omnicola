# frozen_string_literal: true

require 'bcrypt'
require_relative '../db/user.rb'
require_relative './models'

# user related usecases
module UserUseCases
  include UserDataStore

  def create_admin(first_name, last_name, email, password)
    u = Models::User.new(first_name: first_name,
                         last_name: last_name,
                         email: email,
                         role: Models::ADMIN)
    create_user(u, password)
  end

  def get_token(email, password)
    u = get_user_by_email(email)
    if BCrypt::Password.new(u.pwd_hash) == password
      "token"
    end
  end
end
