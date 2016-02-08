# == Schema Information
#
# Table name: registered_voter_histories
#
#  id                    :integer          not null
#  vtrid                 :integer          not null
#  election_date         :string(255)
#  election_description  :string(255)
#  election_type         :string(255)
#  political_party       :string(255)
#  election_code         :string(255)
#  voting_method         :string(255)
#  date_of_voting        :string(255)
#  precinct              :string(255)
#  early_voting_location :string(255)
#  juristiction_code     :string(255)
#  county_name           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class RegisteredVoterHistory < ActiveRecord::Base
end
