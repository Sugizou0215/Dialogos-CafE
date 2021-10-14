class HomesController < ApplicationController

  before_action :authenticate_user!, only: [:help]

  def top
    @events = Event.all
    @new_events = Event.all.page(params[:page]).reverse_order.per(3)
  end

  def about
  end
end
