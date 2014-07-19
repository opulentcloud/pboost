json.array!(@petition_headers) do |petition_header|
  json.extract! petition_header, :id, :voters_of, :baltimore_city, :party_affiliation, :unaffiliated, :name, :address, :office_and_district, :ltgov_name, :ltgov_address
  json.url petition_header_url(petition_header, format: :json)
end
