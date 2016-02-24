class CreateVotingHistories < ActiveRecord::Migration
  def change
    create_table :voting_histories do |t|
      t.string :encrypted_member_id
      t.references :poll
      t.boolean :has_voted, null: false, default: false
      t.string :token

      t.timestamps null: false
      t.index :poll_id
    end
  end
end
