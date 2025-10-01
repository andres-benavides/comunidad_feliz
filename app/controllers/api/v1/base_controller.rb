# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: { errors: [e.message] }, status: :not_found
      end
    end
  end
end