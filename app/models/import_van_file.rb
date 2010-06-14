class ImportVanFile

	def self.load_voter(row)
		Voter.new(
			:vote_builder_id => row[0].to_s.strip.to_i,
			:last_name => row[1].to_s.strip,
			:first_name => row[2].to_s.strip,
			:middle_name => row[3].to_s.strip,
			:suffix => row[4].to_s.strip,
			:salutation => row[5].to_s.strip,
			:phone => row[23].to_s.strip,
			:home_phone => row[24].to_s.strip,
			:work_phone => row[25].to_s.strip,
			:work_phone_ext => row[26].to_s.strip,
			:cell_phone => row[27].to_s.strip,
			:email => row[28].to_s.strip,
			:party => row[36].to_s.strip,
			:sex => row[37].to_s.strip,
			:age => row[38].to_s.strip,
			:dob => row[39].to_s.strip,
			:dor => row[40].to_s.strip,
			:state_file_id => row[68].to_s.strip)
	end

	def self.load_address(row)
		Address.new(
			:street_no => row[6].to_s.strip,
			:street_no_half => row[7].to_s.strip,
			:street_prefix => row[8].to_s.strip,
			:street_name => row[9].to_s.strip,
			:street_type => row[10].to_s.strip,
			:street_suffix => row[11].to_s.strip,
			:apt_type => row[12].to_s.strip,
			:apt_no => row[13].to_s.strip,
			:city => row[14].to_s.strip,
			:state => row[15].to_s.strip,
			:zip5 => row[16].to_s.strip,
			:zip4 => row[17].to_s.strip)
	
	end

	def self.build_voter_history(v, row)
			v.voting_history_voters.create!(
				:election_year => 2008,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[41].to_s.strip) unless row[41].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2006,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[42].to_s.strip) unless row[42].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2004,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[43].to_s.strip) unless row[43].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2002,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[44].to_s.strip) unless row[44].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2000,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[45].to_s.strip) unless row[45].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1998,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[46].to_s.strip) unless row[46].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1996,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[47].to_s.strip) unless row[47].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1994,
				:election_month => nil,
				:election_type => 'G',
				:voter_type => row[48].to_s.strip) unless row[48].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2007,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[49].to_s.strip) unless row[49].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2005,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[50].to_s.strip) unless row[50].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2003,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[51].to_s.strip) unless row[51].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2002,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[52].to_s.strip) unless row[52].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2001,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[53].to_s.strip) unless row[53].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2000,
				:election_month => nil,
				:election_type => 'MG',
				:voter_type => row[54].to_s.strip) unless row[54].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2007,
				:election_month => nil,
				:election_type => 'MP',
				:voter_type => row[55].to_s.strip) unless row[55].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2005,
				:election_month => nil,
				:election_type => 'MP',
				:voter_type => row[56].to_s.strip) unless row[56].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2003,
				:election_month => nil,
				:election_type => 'MP',
				:voter_type => row[57].to_s.strip) unless row[57].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2001,
				:election_month => nil,
				:election_type => 'MP',
				:voter_type => row[58].to_s.strip) unless row[58].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1999,
				:election_month => nil,
				:election_type => 'MP',
				:voter_type => row[59].to_s.strip) unless row[59].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2008,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[60].to_s.strip) unless row[60].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2006,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[61].to_s.strip) unless row[61].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2004,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[62].to_s.strip) unless row[62].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2002,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[63].to_s.strip) unless row[63].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 2000,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[64].to_s.strip) unless row[64].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1998,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[65].to_s.strip) unless row[65].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1996,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[66].to_s.strip) unless row[66].to_s.strip == ''

			v.voting_history_voters.create!(
				:election_year => 1994,
				:election_month => nil,
				:election_type => 'P',
				:voter_type => row[67].to_s.strip) unless row[67].to_s.strip == ''
	
	end

	def self.update_unlinked_addresses
		newrec = false
		cnt = 0
		fnd_cnt = 0
		to_find = []
		FasterCSV.foreach("#{RAILS_ROOT}/db/migrate/fixtures/unlinked_voters.csv", :headers => true, :col_sep => "\t") do |row|
			to_find.push(row[0].to_s.strip.to_i)
		end
		
		FasterCSV.foreach("#{RAILS_ROOT}/db/migrate/fixtures/voters_maryland.csv", :headers => true, :col_sep => "\t") do |row|
			if to_find.include?(row[0].to_s.strip.to_i)
				v = load_voter(row)
				a = load_address(row)
				voter = Voter.find_by_vote_builder_id(v.vote_builder_id)
				address = Address.find_by_address_hash(a.hash_full_address)
				voter = v if voter.nil?
				address = a if address.nil? 
				voter.address = address
				voter.search_index = voter.build_search
				newrec = voter.new_record?
				voter.save!

				if newrec
					build_voter_history(voter, row)
				end
				
				fnd_cnt += 1
				puts "Found: #{fnd_cnt.to_s}" 
			end

			cnt += 1
			puts cnt				

		end

	end

	def self.link_addresses
		cnt = 0
		FasterCSV.foreach("#{RAILS_ROOT}/db/migrate/fixtures/voters_maryland.csv", :headers => true, :col_sep => "\t") do |row|
			voter = nil
			address = nil

			v = load_voter(row)			
			voter = Voter.find_by_vote_builder_id(v.vote_builder_id)
			if voter.nil?
				a = load_address(row)
				address = Address.find_by_address_hash
				(a.hash_full_address)
				if address.nil?
					address = a
				end
				voter.address = address
				voter.search_index = voter.build_search
				voter.save!
				build_voter_history(voter, row)
			end
			cnt += 1
			puts cnt
		end
	end

	def self.add_missing_voters
		cnt = 0
		FasterCSV.foreach("#{RAILS_ROOT}/db/migrate/fixtures/voters_maryland.csv", :headers => true, :col_sep => "\t") do |row|
			voter = nil
			address = nil

			v = load_voter(row)			

			voter = Voter.find_by_vote_builder_id(v.vote_builder_id)
			if voter.nil?
				a = load_address(row)
				address = Address.find_by_address_hash(a.hash_full_address)
				if address.nil?
					address = a
				end
				voter.address = address
				voter.search_index = voter.build_search
				voter.save!
				build_voter_history(voter, row)
			end
			cnt += 1
			puts cnt
		end
	
	end

	#path assumed as current project /db/migrate/fixtures/
	def self.import_vam_file(file_name)
		cnt = 0
		waiting = true
		last_id = Voter.last.state_file_id
		FasterCSV.foreach("#{RAILS_ROOT}/db/migrate/fixtures/#{file_name}", :headers => true, :col_sep => "\t") do |row|

			if waiting == false
			begin
			Voter.transaction do
			v = Voter.create(
					:vote_builder_id => row[0].to_s.strip.to_i,
					:last_name => row[1].to_s.strip,
					:first_name => row[2].to_s.strip,
					:middle_name => row[3].to_s.strip,
					:suffix => row[4].to_s.strip,
					:salutation => row[5].to_s.strip,
					:phone => row[23].to_s.strip,
					:home_phone => row[24].to_s.strip,
					:work_phone => row[25].to_s.strip,
					:work_phone_ext => row[26].to_s.strip,
					:cell_phone => row[27].to_s.strip,
					:email => row[28].to_s.strip,
					:party => row[36].to_s.strip,
					:sex => row[37].to_s.strip,
					:age => row[38].to_s.strip,
					:dob => row[39].to_s.strip,
					:dor => row[40].to_s.strip,
					:state_file_id => row[68].to_s.strip)

			ImportVanFile.build_voter_history(v, row)

			end
			rescue Exception => err
			debugger
			puts err
			end
		end

		if row[68].to_s.strip == last_id
			waiting = false
		end
		cnt += 1
		puts cnt
		end
	end

end

