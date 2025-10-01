# frozen_string_literal: true

class BookSerializer < ApplicationSerializer
  def as_json(*)
    {
      id: record.id,
      title: record.title,
      author: record.author
    }
  end
end
