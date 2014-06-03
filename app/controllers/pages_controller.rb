class PagesController < ApplicationController

  def index
    @running = Challenge.running.visible.sorted
    @upcoming = Challenge.upcoming.visible.sorted
    @archive = Challenge.visible.sorted.where('to_date < ?', Date.today)
  end

  def about
  end

end
