class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ edit update destroy ]

  def edit
    redirect_to root_path unless current_user == @user
  end

  def update
    redirect_to root_path unless current_user == @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: "Your profile was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to root_path unless current_user == @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :image,
                                   :time_zone)
    end
end
