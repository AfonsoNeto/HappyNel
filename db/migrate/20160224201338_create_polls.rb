class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.float :acumulated_score, null: false, default: 0
      t.float :final_result		 , null: false, default: 0

      t.timestamps null: false
    end
  end
end
