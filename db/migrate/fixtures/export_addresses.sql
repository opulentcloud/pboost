SELECT 
	address_hash as uid,
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
	zip5 as zip,
	zip4
FROM
	addresses;

