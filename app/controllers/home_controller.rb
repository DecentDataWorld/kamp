class HomeController < ApplicationController
  def index
    @page_title = 'Home'
    @collections = Collection.limit(5).where('private = ? AND approved = ? AND newsletter_only = ? AND image_file_name is not null', false, true, false).order('updated_at desc')
    @organizations = Organization.limit(3).where('approved = ?', true).order('updated_at desc')
    @resources = Resource.limit(4).where('private = ? AND approved = ? AND newsletter_only = ? ', false, true, false).order('updated_at desc')
    #@resources_viewed = Resource.limit(4).where('private = ? AND approved = ? AND newsletter_only = ? and (view_count is not null or view_count > 0)', false, true, false).order('view_count desc')
    most_viewed_query = "select resources.id as id, count(impressions.id) as count_impressions from resources inner join impressions on resources.id = impressionable_id where impressions.created_at > (CURRENT_DATE - INTERVAL '60 days') group by resources.id order by count_impressions DESC limit 10"
    most_viewed_records = ActiveRecord::Base.connection.execute(most_viewed_query).to_a
    most_viewed_ids = most_viewed_records.map { |row| row["id"] }
    @banners = Banner.where(visible: true)
    @resources_viewed = Resource.where("id in (?)", most_viewed_ids)
    @tags = Resource.tag_counts_on(:tags).limit(15)
    #@search_results = []
    @featured_searches = FeaturedSearch.home_searches.order(:name)
    @announcements = Announcement.active.is_public.featured.limit(5)
    @events = Event.active.is_public.featured.limit(5)
  end

  def error
    @page_title = 'Something went wrong'
  end
end
