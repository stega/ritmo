class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_admin, except: %i[ index show ]

  # GET /events or /events.json
  def index
    if params[:type]
      @events = Event.where(event_type: params[:type]).order(:date, :time_start)
    elsif params[:tag]
      @events = Event.where("? = ANY (tags)", params[:tag]).order(:date, :time_start)
    elsif params[:search] && !params[:search].blank?
      @events = Event.search_text(params[:search]).order(:date, :time_start)
    else
      @events = Event.all.order(:date, :time_start)
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        @event.update tags: event_params[:tags].reject!(&:blank?)
        format.html { redirect_to events_path, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        @event.update tags: event_params[:tags].reject!(&:blank?)
        format.html { redirect_to events_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name,
                                       :description,
                                       :zoom_link,
                                       :time_start,
                                       :date,
                                       :duration,
                                       :event_type,
                                       :attachment,
                                       :map,
                                       {:tags => []},
                                       :author_id)
    end
end
