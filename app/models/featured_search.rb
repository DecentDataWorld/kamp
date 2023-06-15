class FeaturedSearch < ActiveRecord::Base
  acts_as_taggable

  validates_presence_of :name, :message => "Name is required"

  #has_attached_file :image, :styles => { :xlarge => "470x315>", :large => "300x200>", :medium => "240x160>", :small => "200x130>", :thumb => "100x70>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def get_url
    url =  "/searches/update_search?action=new"
    self.tags.each do |t|
      url = url + "&tags[]=" + t.id.to_s
    end

    return url
  end
end
