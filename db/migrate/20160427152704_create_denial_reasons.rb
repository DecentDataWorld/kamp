class CreateDenialReasons < ActiveRecord::Migration
  def change
    create_table :denial_reasons do |t|
      t.text :reason

      t.timestamps
    end
  end
end
