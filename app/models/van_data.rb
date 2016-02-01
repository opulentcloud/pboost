# == Schema Information
#
# Table name: van_data
#
#  vote_builder_id :string(255)
#  last_name       :string(255)
#  first_name      :string(255)
#  middle_name     :string(255)
#  suffix          :string(255)
#  salutation      :string(255)
#  street_no       :string(255)
#  street_no_half  :string(255)
#  street_prefix   :string(255)
#  street_name     :string(255)
#  street_type     :string(255)
#  street_suffix   :string(255)
#  apt_type        :string(255)
#  apt_no          :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip5            :string(255)
#  zip4            :string(255)
#  m_address       :string(255)
#  m_city          :string(255)
#  m_state         :string(255)
#  m_zip5          :string(255)
#  m_zip4          :string(255)
#  phone           :string(255)
#  home_phone      :string(255)
#  work_phone      :string(255)
#  work_phone_ext  :string(255)
#  cell_phone      :string(255)
#  email           :string(255)
#  county_name     :string(255)
#  precinct_name   :string(255)
#  precinct_code   :string(255)
#  cd              :string(255)
#  sd              :string(255)
#  hd              :string(255)
#  comm_dist_code  :string(255)
#  party           :string(255)
#  sex             :string(255)
#  age             :string(255)
#  dob             :string(255)
#  dor             :string(255)
#  general_08      :string(255)
#  general_06      :string(255)
#  general_04      :string(255)
#  general02       :string(255)
#  general_00      :string(255)
#  general_98      :string(255)
#  general_96      :string(255)
#  general_94      :string(255)
#  muni_general_07 :string(255)
#  muni_general_05 :string(255)
#  muni_general_03 :string(255)
#  muni_general_02 :string(255)
#  muni_general_01 :string(255)
#  muni_general_00 :string(255)
#  muni_primary_07 :string(255)
#  muni_primary_05 :string(255)
#  muni_primary_03 :string(255)
#  muni_primary_01 :string(255)
#  muni_primary_99 :string(255)
#  primary_08      :string(255)
#  primary_06      :string(255)
#  primary_04      :string(255)
#  primary_02      :string(255)
#  primary_00      :string(255)
#  primary_98      :string(255)
#  primary_96      :string(255)
#  primary_94      :string(255)
#  state_file_id   :string(255)      not null, primary key
#  address_hash    :string(32)
#

# Raw imported data from VAN system file
class VanData < ActiveRecord::Base

  GENERAL_ELECTIONS =['general_08','general_06','general_04','general02','general_00','general_98','general_96','general_94'].freeze
  MUNI_GENERAL_ELECTIONS = ['muni_general_07','muni_general_05','muni_general_03','muni_general_02','muni_general_01','muni_general_00'].freeze
  MUNI_PRIMARY_ELECTIONS = ['muni_primary_07','muni_primary_05','muni_primary_03','muni_primary_01','muni_primary_99'].freeze
  PRIMARY_ELECTIONS = ['primary_08','primary_06','primary_04','primary_02','primary_00','primary_98','primary_96','primary_94'].freeze

  def table_name
    'van_data'
  end
  
  self.primary_key = 'state_file_id'

  # begin public instance methods
	def full_address
	 	if zip4.blank?
			"#{full_street_address}, #{city}, #{state}, #{zip5}"
		else
	    "#{full_street_address}, #{city}, #{state}, #{zip5}-#{zip4}"
	  end
  end

  def full_street_address
    "#{street_no} #{street_no_half} #{street_prefix} #{street_name} #{street_type} #{street_suffix} #{apt_type} #{apt_no}".squeeze(" ").strip
  end

	def hash_full_address
		Digest::MD5.hexdigest(full_address.downcase)
	end
  
  # end public instance methods
  
  # begin public class methods
  def self.build_address_hashes(break_after = false)
    while VanData.where(address_hash: nil).exists? do
      VanData.transaction do
        VanData.where(address_hash: nil).limit(1000).each do |address|
          address.update_attribute(:address_hash, address.hash_full_address)
        end
      end
      break if break_after == true
    end
  end

  def self.voting_histories_populate!
    @elections = [GENERAL_ELECTIONS, MUNI_GENERAL_ELECTIONS, MUNI_PRIMARY_ELECTIONS, PRIMARY_ELECTIONS]

    @election_type = nil
    @elections.each_with_index do |elections,index|
      case index
        when 0 then @election_type = 'G'
        when 1 then @election_type = 'MG'
        when 2 then @election_type = 'MP'
        when 3 then @election_type = 'P'
      end
      
      elections.each do |election|
        @election_year = election.gsub('general02','general_02').split('_').last.to_i
        @election_year += @election_year > 8 ? 1900 : 2000

        puts "Populating #{@election_year} #{@election_type} #{election}..."

        result = nil
        cnt = 0
        while result.nil? || result.try(:cmd_tuples) > 0
          puts cnt += 1
          VotingHistory.transaction do
            result = ActiveRecord::Base.connection.execute( %{
              INSERT INTO voting_histories (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at) \
              SELECT state_file_id, CASE WHEN COALESCE(#{election}, 'N') = '' THEN 'N' ELSE COALESCE(#{election}, 'N') END AS #{election}, \
              #{@election_year} as election_year, null as election_month, '#{@election_type}' as election_type, current_date as created_at, current_date as updated_at \
              FROM van_data \
              WHERE NOT EXISTS (SELECT h.id FROM voting_histories h WHERE h.state_file_id = van_data.state_file_id AND h.election_type = '#{@election_type}' AND h.election_year = #{@election_year}) \
              LIMIT 10000;
            }, :skip_logging)
          end
        end
      end
    end
  end
  # end public class methods
end
