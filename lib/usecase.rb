# frozen_string_literal: true

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
end
