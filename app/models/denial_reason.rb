class DenialReason < ActiveRecord::Base
  validates_presence_of :reason, :message => "Denial Reason is required"
end
