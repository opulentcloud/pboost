SELECT
	voters.last_name, voters.first_name, voters.middle_name, voters.suffix, voters.salutation, voters.phone, voters.home_phone, voters.work_phone, voters.work_phone_ext, voters.cell_phone, voters.email, voters.party, voters.sex, voters.age, voters.dob, voters.dor, voters.state_file_id,
	TRIM(REPLACE(REPLACE((street_no || ' ' ||
		street_no_half || ' ' ||
		street_prefix || ' ' ||
		street_name || ' ' ||
		street_type || ' ' ||
		street_suffix || ' ' ||
		apt_type || ' ' ||
		apt_no), '   ', ' '), '  ', ' ')) as address,
	city,
	state,
	zip5,
	zip4,
	precinct_name, precinct_code, cd, sd, hd, comm_dist_code
FROM
	voters
INNER JOIN addresses ON addresses.id = voters.address_id
WHERE
	addresses.state = 'MD'
	AND addresses.county_name = 'Montgomery'

