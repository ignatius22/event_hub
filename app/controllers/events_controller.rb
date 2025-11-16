class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :publish, :cancel]
  after_action :verify_authorized, except: [:index, :my_events]

  def index
    @events = Event.published.upcoming.ordered_by_date.includes(:category, :user, :registrations)

    # Apply filters
    @events = @events.by_category(params[:category]) if params[:category].present?
    @events = @events.search(params[:search]) if params[:search].present?

    @pagy, @events = pagy(@events)
    @categories = Category.ordered
  end

  def show
    authorize @event
    @registration = current_user&.registrations&.find_by(event: @event)
  end

  def new
    @event = current_user.events.build
    authorize @event
    @categories = Category.ordered
  end

  def create
    @event = current_user.events.build(event_params)
    authorize @event

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      @categories = Category.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
    @categories = Category.ordered
  end

  def update
    authorize @event

    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      @categories = Category.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted."
  end

  def publish
    authorize @event

    if @event.update(status: :published)
      redirect_to @event, notice: "Event has been published."
    else
      redirect_to @event, alert: "Unable to publish event."
    end
  end

  def cancel
    authorize @event

    if @event.update(status: :cancelled)
      redirect_to @event, notice: "Event has been cancelled."
    else
      redirect_to @event, alert: "Unable to cancel event."
    end
  end

  def my_events
    @events = current_user.events.includes(:category, :registrations).ordered_by_date
    @pagy, @events = pagy(@events)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :location, :address,
      :starts_at, :ends_at, :capacity, :category_id,
      :cover_image, :status
    )
  end
end
