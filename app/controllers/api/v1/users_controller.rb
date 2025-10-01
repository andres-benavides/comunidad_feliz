# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def index
        users = User.order(:name)
        render json: users.map { |u| UserSerializer.new(u).as_json }
      end
    end
  end
end