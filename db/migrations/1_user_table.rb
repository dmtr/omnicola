# frozen_string_literal: true

require 'sequel'
require_relative '../../lib/models'

Sequel.migration do
  up do
    create_enum(:user_role, Models::USER_ROLES)

    create_table(:user_account) do
      primary_key :id, type: :Bignum
      String :first_name, null: false, size: 200
      String :last_name, null: false, size: 200
      String :email, null: false, size: 200, unique: true
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
      user_role :role
      String :pwd_hash, null: false, size: 100

      index :created_at
      index :email
    end

    create_function(:set_updated_at, <<-SQL, language: :plpgsql, returns: :trigger)
      BEGIN
	NEW.updated_at := CURRENT_TIMESTAMP;
	RETURN NEW;
      END;
    SQL

    create_trigger(:user_account, :trg_updated_at, :set_updated_at, events: :update, each_row: true, when: {Sequel[:new][:updated_at] => Sequel[:old][:updated_at]})
  end

  down do
    drop_trigger(:user_account, :trg_updated_at)
    drop_table(:user_account)
    drop_enum(:user_role)
    drop_function(:set_updated_at)
  end
end
