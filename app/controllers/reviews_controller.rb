class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def create
    @review = @event.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @event, notice: 'Review submitted successfully!'
    else
      redirect_to @event, alert: @review.errors.full_messages.join(', ')
    end
  end

  def destroy
    @review = @event.reviews.find(params[:id])
    authorize_review(@review)

    @review.destroy
    redirect_to @event, notice: 'Review deleted.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def authorize_review(review)
    unless review.user == current_user || current_user.admin?
      redirect_to @event, alert: 'Not authorized.'
    end
  end
end
