class CreateVotersNamesView < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE OR REPLACE VIEW voters_names AS
        SELECT address_id AS voter_address_id, string_agg(REGEXP_REPLACE(TRIM(CONCAT(voters.last_name, ', ', voters.first_name, ' ', voters.middle_name, ' ', to_char(voters.dob, 'MM/DD/YYYY'))), ' +', ' ', 'g'), ', ') AS name_list
        FROM voters
        INNER JOIN "addresses" ON "addresses"."id" = "voters"."address_id" 
        WHERE voters.dob > (SELECT MIN(v2.dob) FROM voters as v2 WHERE v2.address_id = addresses.id)
        GROUP BY voters.address_id;
    }
  end
  
  def self.down
    execute %{DROP VIEW voters_names;}
  end
end


