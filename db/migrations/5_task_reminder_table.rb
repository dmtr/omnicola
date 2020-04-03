# frozen_string_literal: true

require 'sequel'
require_relative '../../lib/models'

Sequel.migration do
  up do
    create_enum(:task_reminder_status, Models::TASK_REMINDER_STATUSES)

    create_table(:task_reminder) do
      primary_key :id, type: :Bignum
      foreign_key :task_id, :task, null: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :remind_at, null: false
      task_reminder_status :status, default: Models::ACTIVE

      index :status
      index :remind_at
      index :updated_at
    end
    create_trigger(:task_reminder, :trg_updated_at, :set_updated_at, events: :update, each_row: true, when: {Sequel[:new][:updated_at] => Sequel[:old][:updated_at]})
  end

  down do
    drop_trigger(:task_reminder, :trg_updated_at)
    drop_table :task_reminder
    drop_enum :task_reminder_status
  end
end
