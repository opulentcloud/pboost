class Voter < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :address
	has_many :voting_history_voters, :dependent => :destroy
	has_and_belongs_to_many :gis_regions

	#====== INSTANCE METHODS ======
	def of_6_to_word(elec_type)
		r = self.of_6(elec_type)
		p = (r.to_f/6.to_f*100.to_f).to_int
		"#{r}/6 = #{p}%"
	end

	def quality
		y = Date.today - ((2 * 5).years)
		self.voting_history_voters.all(:conditions => "election_year >= #{y} AND election_type = 'P'").count
	end

	def of_6(elec_type)
		d = case elec_type
				when 'P' then 2
				when 'G' then 2
				else 3 end
		y = Date.today - ((d * 6).years)
		self.voting_history_voters.all(:conditions => "election_year >= #{y} AND election_type = '#{elec_type}'").count
	end

	def general_voting_history
		primary_voting_history
	end

	def primary_voting_history
		r = []
		t = Date.today
		cnt = 1
		self.voting_history_voters.each_with_index do |h,index|
			y =	(t - 2.years).year
			r.push("#{index} of #{cnt}") if h.election_year == t
			cnt += 1
			t -= 2.years
			break if t.year < 1994
		end
		r
	end
	
	def printable_name
		"#{last_name}, #{first_name} #{middle_name}".upcase
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

