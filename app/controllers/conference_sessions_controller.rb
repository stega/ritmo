class ConferenceSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin, except: %i[ show ]
  def index
  end

  def show
    @conference_session = ConferenceSession.find(params[:id])
  end

  def new
    @conference_session = ConferenceSession.new
  end

  def create
    @conference_session = ConferenceSession.new(conference_session_params)

    respond_to do |format|
      if @conference_session.save
        @conference_session.update tags: conference_session_params[:tags].reject!(&:blank?)
        format.html { redirect_to conference_sessions_path, notice: "Session was successfully created." }
        format.json { render :show, status: :created, location: @conference_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conference_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @conference_session = ConferenceSession.find(params[:id])
  end

  # PATCH/PUT /conference_sessions/1 or /conference_sessions/1.json
  def update
    respond_to do |format|
      if @conference_session.update(conference_session_params)
        @conference_session.update tags: conference_session_params[:tags].reject!(&:blank?)
        format.html { redirect_to conference_sessions_path, notice: "Session was successfully updated." }
        format.json { render :show, status: :ok, location: @conference_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conference_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_sessions/1 or /conference_sessions/1.json
  def destroy
    @conference_session.destroy
    respond_to do |format|
      format.html { redirect_to conference_sessions_url, notice: "Session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference_session
      @conference_session = ConferenceSession.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def conference_session_params
      params.require(:conference_session).permit(:name,
                                                 :chair,
                                                 :type,
                                                 :start,
                                                 :end)
    end
end
