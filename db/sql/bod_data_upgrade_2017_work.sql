SELECT 
	DISTINCT vtrid,lastname,firstname,middlename,suffix,house_number,house_suffix,street_predirection,streetname,streettype,street_postdirection,unittype,unitnumber,non_std_address,residentialcity,residentialstate,residentialzip5,residentialzip4,mailingaddress,mailingcity,mailingstate,mailingzip5,mailingzip4,status_code,party,gender,congressional_districts,legislative_districts,councilmanic_districts,ward_districts,municipal_districts,school_districts,precinct,split,county_registration_date,state_registration_date,county 
FROM 
	registered_voters_data rvd
LIMIT 1

delete from registered_voters_data where vtrid='VTR_ID';

select count(*) from voters;

SELECT r.lastname, r.firstname, r.middlename, r.suffix, r.party, SUBSTRING(r.gender,1,1) as sex, NULL as dob, r.state_registration_date::date, r.vtrid::int FROM registered_voters_data r
      LEFT OUTER JOIN voters ON voters.state_file_id = r.vtrid::int
      WHERE voters.id IS NULL
      LIMIT 2;

SELECT COUNT(*) FROM registered_voters_data WHERE address_hash IS NOT NULL;

END
select DISTINCT election_type, election_year FROM voting_histories ORDER BY election_type, election_year

SELECT 
	DISTINCT vote5 /* vtrid,vote1,vote2,vote3,vote4,vote5 */
FROM 
	registered_voters_data rvd
ORDER BY
	vote5
/* WHERE
	rvd.vtrid = '6132136' */

SELECT * FROM registered_voters_data LIMIT 1

select count(*) from addresses

SELECT * FROM voting_histories LIMIT 100
UPDATE voting_histories SET election_month = 11 WHERE election_type IN ('G','GG') AND election_month IS NULL

SELECT COUNT(*) FROM voters WHERE address_id IS NOT NULL

select * from voters where address_id is null limit 1