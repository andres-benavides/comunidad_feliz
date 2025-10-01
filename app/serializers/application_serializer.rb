# frozen_string_literal: true

class ApplicationSerializer
  def initialize(record)
    @record = record
  end

  def as_json(*)
    raise NotImplementedError
  end

  private
  attr_reader :record
end
