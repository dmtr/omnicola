# frozen_string_literal: true

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_, args|
    require 'sequel/core'
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(ENV.fetch('DATABASE_URL')) do |db|
      db.extension :pg_enum
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end
end

namespace :app do
  desc 'Create admin'
  task :create_admin, [:first_name, :last_name, :email, :password] do |_, args|
    require_relative './lib/usecase'
    include UserUseCases
    create_admin(args.first_name, args.last_name, args.email, args.password)
  end
end
