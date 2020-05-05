# This migration comes from devresults (originally 20161122154013)
class CreateDevresultsGrades < ActiveRecord::Migration
  def change
    create_table :devresults_grades do |t|
      t.string :value
      t.text :text
      t.integer :result_id

      t.timestamps null: false
    end
  end
end
