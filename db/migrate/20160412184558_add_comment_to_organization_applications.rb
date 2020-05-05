class AddCommentToOrganizationApplications < ActiveRecord::Migration
  def change
    add_column :organization_applications, :comment, :text
  end
end
