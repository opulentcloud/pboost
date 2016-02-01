class AddIndexVoteBuilderIdOnVoters < ActiveRecord::Migration
  def change
    add_index :voters, :vote_builder_id, unique: true
  end
end
