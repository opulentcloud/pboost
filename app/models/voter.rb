class Voter < ActiveRecord::Base

  # begin associations
  belongs_to :address
  has_many :votes, class_name: 'VotingHistory'
  # end associations

  # begin public instance methods  
	def full_name
		"#{first_name} #{middle_name} #{last_name} #{suffix}".upcase.squeeze(' ')
	end

	def build_search
		first_four = self.first_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = self.last_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		all = self.address.street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.build_search_index(first_name, last_name, street_no)
		first_four = first_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = last_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		all = street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
  end

  def self.build_search_indexes
    Voter.where(search_index: nil).find_in_batches(:batch_size => 1000) do |batch|
      Voter.transaction do
        batch.each do |voter|
          voter.update_attribute(:search_index, voter.build_search)
        end
      end
    end
  end
  
  def self.link_addresses
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
