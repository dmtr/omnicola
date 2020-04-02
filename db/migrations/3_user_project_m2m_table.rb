# frozen_string_literal: true

require 'sequel'
require_relative '../../lib/models'

Sequel.migration do
  up do
    create_table(:user_project_m2m) do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :user_account
      foreign_key :project_id, :project

      index %i[user_id project_id]
    end
  end

  down do
    drop_table :user_project_m2m
  end
end
