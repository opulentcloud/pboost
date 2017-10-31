﻿INSERT INTO registered_voters_history_updates (state_file_id, voter_type, election_year, election_month, election_type, created_at, updated_at)
SELECT registered_voters_data.vtrid AS state_file_id,
'P' AS voter_type,
CASE split_part(vote5, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END AS election_year,
CASE vote5 WHEN '2010 GUBERNATORIAL GENERAL ELECTION' THEN 11 WHEN '2016 PRESIDENTIAL PRIMARY ELECTION' THEN 4 END AS election_month,
CASE vote5 WHEN '2010 GUBERNATORIAL GENERAL ELECTION' THEN 'GG' WHEN '2016 PRESIDENTIAL PRIMARY ELECTION' THEN 'P' END AS election_type,
current_date as created_at, current_date as updated_at
FROM registered_voters_data
WHERE (CASE split_part(vote5, ' ', 1) WHEN '2010' THEN 2010 WHEN '2016' THEN 2016 END) IS NOT NULL
ORDER BY vtrid
LIMIT 1000

 vote1
 -----------------
"2006 GUBERNATORIAL PRIMARY"
"2012 PRESIDENTIAL GENERAL ELECTION"
"GUBERNATIONAL PRIMARY - 2006"
"Gubernatorial Primary - 2006"
"GUBERNATORIAL PRIMARY 2006"
"GUBERNATORIAL PRIMARY - 2006"
"GUBERNATORIAL PRIMARY-2006"
"GUBERNATORIAL PRIMARY ELECTION  - 2006"
"GUB. PRIMARY 2006"
"Primary Election - 2006"

 vote2
 -----------------
"2006 GUBERNATORIAL GENERAL ELECTION"
"2014 GUBERNATORIAL PRIMARY ELECTION"
"GENERAL ELECTION 2006"
"GENERAL ELECTION - 2006"
"GENERAL ELECTION-2006"
"GENERAL ELECTIONS - 2006"
"GUBERNATORIAL GENERAL - 2006"
"GUBERNATORIAL GENERAL ELECTION - 2006"
"GUB. GENERAL ELECTION"

vote3
----------------------
"2012 PRESIDENTIAL PRIMARY ELECTION"
"2014 GUBERNATORIAL GENERAL ELECTION"

vote4
----------------------
"2010 GUBERNATORIAL PRIMARY ELECTION"
"2016 PRESIDENTIAL GENERAL ELECTION"

vote5
----------------------
"2010 GUBERNATORIAL GENERAL ELECTION"
"2016 PRESIDENTIAL PRIMARY ELECTION"