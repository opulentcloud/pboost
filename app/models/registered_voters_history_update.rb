# == Schema Information
#
# Table name: registered_voters_history_updates
#
#  id             :integer          not null, primary key
#  state_file_id  :integer
#  voter_type     :string(255)
#  election_year  :integer
#  election_month :integer
#  election_type  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class RegisteredVotersHistoryUpdate < ActiveRecord::Base
end
