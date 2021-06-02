class ResearchersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_researcher, only: %i[ show edit update destroy ]

  # GET /researchers or /researchers.json
  def index
    @researchers = Researcher.all.order(name: :asc)
  end

  # GET /researchers/1 or /researchers/1.json
  def show
  end

  # GET /researchers/new
  def new
    @researcher = Researcher.new
  end

  # GET /researchers/1/edit
  def edit
  end

  # POST /researchers or /researchers.json
  def create
    @researcher = Researcher.new(researcher_params)

    respond_to do |format|
      if @researcher.save
        format.html { redirect_to @researcher, notice: "Researcher was successfully created." }
        format.json { render :show, status: :created, location: @researcher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @researcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /researchers/1 or /researchers/1.json
  def update
    respond_to do |format|
      if @researcher.update(researcher_params)
        format.html { redirect_to @researcher, notice: "Researcher was successfully updated." }
        format.json { render :show, status: :ok, location: @researcher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @researcher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /researchers/1 or /researchers/1.json
  def destroy
    @researcher.destroy
    respond_to do |format|
      format.html { redirect_to researchers_url, notice: "Researcher was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_researcher
      @researcher = Researcher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def researcher_params
      params.require(:researcher).permit(:name, :about, :image, :phone, :email)
    end
end
