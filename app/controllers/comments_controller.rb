class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def create
    @comment = @event.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @event, notice: 'Comment added successfully.' }
        format.turbo_stream
      end
    else
      redirect_to @event, alert: 'Failed to add comment.'
    end
  end

  def destroy
    @comment = @event.comments.find(params[:id])
    authorize @comment

    @comment.destroy
    redirect_to @event, notice: 'Comment deleted.'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize(comment)
    unless comment.user == current_user || current_user.admin?
      redirect_to @event, alert: 'Not authorized.'
    end
  end
end
