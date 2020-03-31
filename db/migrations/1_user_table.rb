# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  up do
    create_enum(:user_role, %w[admin project_owner team_member])

    create_table(:user_account) do
      primary_key :id, type: :Bignum
      String :first_name, null: false, size: 200
      String :last_name, null: false, size: 200
      String :email, null: false, size: 200, unique: true
      DateTime :created_at, default: :NOW.sql_function
      DateTime :updated_at, default: :NOW.sql_function
      user_role :role

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
    drop_table(:user_account)
    drop_enum(:user_role)
    drop_function(:set_updated_at)
    drop_trigger(:user_account, :trg_updated_at)
  end
end
