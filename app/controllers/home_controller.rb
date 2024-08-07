class HomeController < ApplicationController
  def index
    @featured_searches = FeaturedSearch.home_searches.order(:name)
    @announcements = Announcement.active.is_public.featured.limit(5)
    @events = Event.active.is_public.featured.limit(5)
  end

  def error
    @page_title = 'Something went wrong'
  end
end
