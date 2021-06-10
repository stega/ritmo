class ProgrammeController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_event, only: %i[ show edit update destroy ]
  # before_action :authenticate_admin, except: %i[ index show ]

  def index

  end
end