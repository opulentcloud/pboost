SELECT 
	voters.first_name || ' ' || voters.last_name as name,
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
	zip5 || '-' || zip4 as zip
FROM
	addresses, voters
WHERE
	state = 'MD'
AND
	county_name = 'Baltimore'
AND
	EXISTS(SELECT * FROM voters WHERE voters.address_id = addresses.id AND voters.party = 'D')
AND
	voters.id = (SELECT v.id FROM voters v WHERE v.address_id = addresses.id AND v.party = 'D' ORDER BY v.sex DESC, v.age DESC LIMIT 1)

