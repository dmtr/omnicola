# frozen_string_literal: true

require 'sequel'

Sequel.extension :migration
DB.extension :pg_enum
