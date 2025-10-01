# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < BaseController
      def index
        reviews = Review.includes(:user, :book).order(created_at: :desc)
        render json: reviews.map { |r| ReviewSerializer.new(r).as_json }
      end

      def create
        result = ::Reviews::CreateReview.call(review_params.to_h.symbolize_keys)

        if result.success?
          render json: ReviewSerializer.new(result.review).as_json, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def review_params
        params.require(:review).permit(:book_id, :user_id, :rating, :content)
      end
    end
  end
end