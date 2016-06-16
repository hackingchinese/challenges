class PagesController < ApplicationController

  def index
    @running = Challenge.running.visible.sorted
    @upcoming = Challenge.upcoming.visible.order('from_date asc')
    @archive = Challenge.visible.order('from_date desc').where('to_date < ?', Date.today)
  end


end
