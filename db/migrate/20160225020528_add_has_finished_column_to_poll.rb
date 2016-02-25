class AddHasFinishedColumnToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :has_finished, :boolean, null: false, default: false
  end
end
