# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  def as_json(*)
    {
      id: record.id,
      name: record.name,
      banned: record.banned
    }
  end
end
