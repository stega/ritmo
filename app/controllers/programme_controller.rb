class ProgrammeController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:type]
      @d1_sessions = ConferenceSession.for_date(22).filter_by_type(params[:type])
      @d2_sessions = ConferenceSession.for_date(23).filter_by_type(params[:type])
      @d3_sessions = ConferenceSession.for_date(24).filter_by_type(params[:type])
      @d4_sessions = ConferenceSession.for_date(25).filter_by_type(params[:type])
    elsif params[:tag]
      @d1_sessions = ConferenceSession.for_date(22).filter_by_kw(params[:tag])
      @d2_sessions = ConferenceSession.for_date(23).filter_by_kw(params[:tag])
      @d3_sessions = ConferenceSession.for_date(24).filter_by_kw(params[:tag])
      @d4_sessions = ConferenceSession.for_date(25).filter_by_kw(params[:tag])
    elsif params[:search] && !params[:search].blank?
      @d1_sessions = ConferenceSession.for_date(22).search(params[:search])
      @d2_sessions = ConferenceSession.for_date(23).search(params[:search])
      @d3_sessions = ConferenceSession.for_date(24).search(params[:search])
      @d4_sessions = ConferenceSession.for_date(25).search(params[:search])
    else
      @d1_sessions = ConferenceSession.for_date(22)
      @d2_sessions = ConferenceSession.for_date(23)
      @d3_sessions = ConferenceSession.for_date(24)
      @d4_sessions = ConferenceSession.for_date(25)
    end
  end
end