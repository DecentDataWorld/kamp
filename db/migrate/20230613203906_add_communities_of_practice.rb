class AddCommunitiesOfPractice < ActiveRecord::Migration[7.0]
  def change
    create_table :cops do |t|
      t.string :name
      t.string :description
      t.references :admin, index: true, foreign_key: {to_table: :users}
      t.timestamps
    end

    create_join_table :cops, :users do |t|
      t.index [:cop_id, :user_id]
      t.index [:user_id, :cop_id]
      t.timestamps
    end

    create_join_table :cops, :resources do |t|
      t.index [:cop_id, :resource_id]
      t.index [:resource_id, :cop_id]
      t.timestamps
    end
  end
end
