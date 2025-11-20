class TagsController < ApplicationController
  def index
    @tags = Tag.popular.limit(50)
  end

  def show
    @tag = Tag.find_by!(slug: params[:id])
    @events = @tag.events.published.upcoming.ordered_by_date.page(params[:page])
  end
end
