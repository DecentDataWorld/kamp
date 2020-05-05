class CreateSurveyLogs < ActiveRecord::Migration
  def change
    create_table :survey_logs do |t|
      t.string :model_type
      t.integer :model_id
      t.integer :user_id
      t.string :event

      t.timestamps
    end
  end
end
