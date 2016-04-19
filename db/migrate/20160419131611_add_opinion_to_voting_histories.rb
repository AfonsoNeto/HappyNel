class AddOpinionToVotingHistories < ActiveRecord::Migration
  def change
    add_column :voting_histories, :opinion, :string
  end
end
