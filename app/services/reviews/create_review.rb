module Reviews
  class CreateReview
    Result = Struct.new(:success?, :review, :errors, keyword_init: true)

    def self.call(params) = new(params).call

    def initialize(params)
      @params = params
    end

    def call
      user = User.find(@params[:user_id])
      return failure(['User is banned']) if user.banned?

      if Review.exists?(user_id: @params[:user_id], book_id: @params[:book_id])
        return failure(['Review already exists for this user and book'])
      end

      review = Review.new(review_attrs)

      if review.save
        success(review)
      else
        failure(review.errors.full_messages)
      end
    rescue ActiveRecord::RecordNotUnique
      failure(['Review already exists for this user and book'])
    rescue ActiveRecord::RecordNotFound => e
      failure([e.message])
    end

    private

    def review_attrs
      @params.slice(:book_id, :user_id, :rating, :content)
    end

    def success(review) = Result.new(success?: true, review: review, errors: [])
    def failure(errors) = Result.new(success?: false, review: nil, errors: Array(errors))
  end
end
