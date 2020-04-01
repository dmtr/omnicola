# frozen_string_literal: true

module Models
  ADMIN = 'admin'
  PROJECT_OWNER = 'project_owner'
  TEAM_MEMBER = 'team_member'
  USER_ROLES = [ADMIN, PROJECT_OWNER, TEAM_MEMBER]

  User = Struct.new(:first_name, :last_name, :email, :role, keyword_init: true)
end
