class Voter < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :address
	has_many :voting_history_voters, :dependent => :destroy
	has_and_belongs_to_many :gis_regions

	#====== INSTANCE METHODS ======
	def printable_name
		"#{last_name}, #{first_name} #{middle_name}"
	end
	
	def build_search
		first_four = self.first_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		second_four = self.last_name.to_s.strip.upcase.gsub(/[^A-Z|\s]/,'')[0,4].ljust(4,'X') rescue ''
		all = self.address.street_no.to_s.strip.upcase rescue ''
		first_four+second_four+all
	end
	
	#===== CLASS METHODS ======
	def self.cleanup_duplicates
	 	@sql = 'DELETE FROM voters WHERE id = (select id from voters where (select count(v.*) from voters v where v.vote_builder_id = voters.vote_builder_id) > 1 order by id DESC LIMIT 1);'
		while (true)
			@result = ActiveRecord::Base.connection.execute(@sql)
			if @result.class.to_s != 'PGresult'
				break;
			end
		end
	end
end

