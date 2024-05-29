class Cop < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :resources, dependent: :nullify
  belongs_to :admin, :class_name => 'User'
  has_many :featured_searches, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :announcements, dependent: :destroy
  scope :admin, -> (user_id) { where admin_id: user_id }

  validates_presence_of :name

  def self.is_user_cop_admin(user)
    return Cop.joins(:users).where("users.id = ? and cops.admin_id = ?", user.id, user.id).first
  end

  def private_resources
    return Resource.where("cop_id = ?", self.id).where("cop_private = ?", true)
  end

  def event_email_body(event)
    "Dear #{self.name} Members,
    %0D%0A%0D%0AWe are excited to inform you about an upcoming event within our Community of Practice. Here are the details:
    %0D%0A%0D%0AEvent Title: #{event.name}
    %0D%0ADate: #{event.start_date.strftime("%Y-%m-%d")}
    %0D%0ALocation: #{event.location}
    %0D%0ADescription: #{event.long_description}
    %0D%0A%20%20%20%20%20[Provide a brief description of the event, including its purpose, topics to be covered, and any special guests or speakers.]
    %0D%0ARegistration:
    %0D%0A%20%20%20%20%20[Include instructions on how members can register for the event, including any registration links or forms.]

    %0D%0A%0D%0AIf you have any questions or need further information, please don't hesitate to reach out to #{event.user.name} at #{event.user.email}.

    %0D%0A%0D%0AThank you for your ongoing commitment to our Community of Practice. We look forward to seeing you at the event!

    %0D%0A%0D%0ABest regards,
    %0D%0A#{self.name} Administrators"
  end

end