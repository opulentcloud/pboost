# == Schema Information
#
# Table name: voters
#
#  id              :integer          not null, primary key
#  vote_builder_id :integer
#  last_name       :string(32)
#  first_name      :string(32)
#  middle_name     :string(32)
#  suffix          :string(4)
#  salutation      :string(32)
#  phone           :string(10)
#  home_phone      :string(10)
#  work_phone      :string(10)
#  work_phone_ext  :string(10)
#  cell_phone      :string(10)
#  email           :string(100)
#  party           :string(5)
#  sex             :string(1)
#  age             :integer
#  dob             :date
#  dor             :date
#  state_file_id   :string(10)
#  search_index    :string(13)
#  created_at      :datetime
#  updated_at      :datetime
#  address_id      :integer
#

class Voter < ActiveRecord::Base

  DATE_SEARCH_FIELDS =  %w{dob dor}

  #exclude some fields from ransack search  
  UNRANSACKABLE_ATTRIBUTES = ['id','vote_builder_id','address_id','search_index','created_at','updated_at']

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

  # begin associations
  belongs_to :address
  has_many :votes, class_name: 'VotingHistory'
  has_one :registered_voters_data, foreign_key: :vtrid, primary_key: :state_file_id
  # end associations

  # begin public instance methods  
	def full_name
		"#{first_name} #{middle_name} #{last_name} #{suffix}".upcase.squeeze(' ')
	end

	def build_search
		first_four = self.first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = self.last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		all = self.address.street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |order|
        csv << voter.attributes.values_at(*column_names)
      end
    end
  end
  # end public class methods

  def self.build_search_index(first_name, last_name, street_no)
		first_four = first_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = last_name.to_s.strip.upcase.gsub(/[^A-Z]/,'')[0,4].ljust(4,'X') rescue ''
		all = street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
  end

  def self.build_search_indexes_by_batch(voter_ids)
    Voter.where(id: voter_ids).each do |voter|
      voter.update_attribute(:search_index, voter.build_search)    
    end
  end

  def self.build_search_indexes
    Voter.select(:id).where(search_index: nil).find_in_batches(:batch_size => 1000) do |batch|
      Voter.delay.build_search_indexes_by_batch(batch.map(&:id))
    end
  end
 
  def self.link_addresses_from_registered_voters_data
    query = %{
      UPDATE voters 
        SET address_id = result.address_id
      FROM
        (SELECT addresses.id as address_id, voters.id as voter_id FROM registered_voters_data 
          INNER JOIN voters on voters.state_file_id = registered_voters_data.vtrid 
          INNER JOIN addresses ON addresses.address_hash = registered_voters_data.address_hash
          WHERE registered_voters_data.address_hash IS NOT NULL) AS result
      WHERE voters.id = result.voter_id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end
  
  def self.link_addresses_from_van_data
    query = %{
      UPDATE voters 
        SET address_id = result.address_id
      FROM
        (SELECT addresses.id as address_id, voters.id as voter_id FROM van_data 
          INNER JOIN voters on voters.state_file_id = van_data.state_file_id 
          INNER JOIN addresses ON addresses.address_hash = van_data.address_hash
          WHERE voters.address_id IS NULL AND van_data.address_hash IS NOT NULL) AS result
      WHERE voters.id = result.voter_id}
    ActiveRecord::Base.connection.execute(query, :skip_logging)
  end
  # end public class methods
end
