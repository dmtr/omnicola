# frozen_string_literal: true

require 'sequel'
require_relative '../../lib/models'

Sequel.migration do
  up do
    create_enum(:project_status, Models::PROJECT_STATUSES)

    create_table(:project) do
      primary_key :id, type: :Bignum
      String :title, null: false, size: 200
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
      project_status :status

      index :created_at
      index :status
    end

    create_trigger(:project, :trg_updated_at, :set_updated_at, events: :update, each_row: true, when: {Sequel[:new][:updated_at] => Sequel[:old][:updated_at]})
  end

  down do
    drop_trigger(:project, :trg_updated_at)
    drop_table(:project)
    drop_enum(:project_status)
  end
end
