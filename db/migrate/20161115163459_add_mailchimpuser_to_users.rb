class AddMailchimpuserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_chimp_user, :boolean, default: false
  end
end
