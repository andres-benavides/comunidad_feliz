# frozen_string_literal: true

class BookSerializer < ApplicationSerializer
  def as_json(*)
    {
      id: record.id,
      title: record.title,
      author: record.author,
      rating_summary: rating_summary_json
    }
  end

  private

  def rating_summary_json
    summary = record.rating_summary
    {
      average: summary.average,
      count:   summary.count,
      status:  summary.status
    }
  end
end
