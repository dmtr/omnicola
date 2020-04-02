# frozen_string_literal: true

require 'sequel'
require_relative '../../lib/models'

Sequel.migration do
  up do
    create_enum(:task_status, Models::TASK_STATUSES)

    create_table(:task) do
      primary_key :id, type: :Bignum
      foreign_key :project_id, :project, null: false
      String :title, null: false, size: 200
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
      task_status :status, default: Models::NEW
      column :user_ids, 'integer[]'

      index :status
      index :created_at
      index :updated_at
    end
    create_trigger(:task, :trg_updated_at, :set_updated_at, events: :update, each_row: true, when: {Sequel[:new][:updated_at] => Sequel[:old][:updated_at]})
  end

  down do
    drop_trigger(:task, :trg_updated_at)
    drop_table :task
    drop_enum :task_status
  end
end
