class AddTitleAndSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
    add_column :users, :google, :string
    add_column :users, :linkedin, :string
  end
end
