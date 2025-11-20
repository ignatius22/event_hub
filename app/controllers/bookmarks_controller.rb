class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarked_events = current_user.bookmarked_events.published.ordered_by_date
  end

  def create
    @event = Event.find(params[:event_id])
    @bookmark = current_user.bookmarks.build(event: @event)

    if @bookmark.save
      respond_to do |format|
        format.html { redirect_to @event, notice: 'Event bookmarked!' }
        format.turbo_stream
      end
    else
      redirect_to @event, alert: 'Failed to bookmark event.'
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @event = @bookmark.event
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to @event, notice: 'Bookmark removed.' }
      format.turbo_stream
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:event_id)
  end
end
