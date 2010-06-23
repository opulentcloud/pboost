pdf.font 'Helvetica'

pdf.repeat(:all) do
	pdf.font_size 20 do
		pdf.text "Walk Sheet - #{@walksheet.political_campaign.candidate_name}", :style => :bold
	end
	pdf.font('Helvetica', :style => :bold, :size => 12) do
		pdf.text "Name of Walker:___________________________________                    Date Walked: ____________"
	end

	pdf.move_down(20)
end

ads = [['Address','Voter','Age','M/F','Party']]

ads += @walksheet.voters.all(:joins => :address, :order => 'state, city, street_name, street_prefix, is_odd, street_no, street_no_half, street_type, street_suffix, apt_type, apt_no').map do |a|
		[a.address.full_street_address, a.printable_name, a.age.to_s, a.sex, a.party]
end

#	subtable = Prawn::Table.new(ads, pdf) do |st|
#		st.header = true
#		st.cell_style = { :borders => [] }
#		st.row(0).style(:style => :bold)
#	end

#	pdf.table ([[subtable]])

#	pdf.move_down(20)

#pdf.bounding_box([0, 0], :width => pdf.bounds.width) do
		pdf.table ads do |dt|
			dt.header = true
			dt.cell_style = { :borders => [] }
			dt.row(0).style(:style => :bold)
		end
#end

pdf.font('Helvetica', :style => :italic, :size => 8) do
	pdf.number_pages "politicalboost.com <page> of <total>", [pdf.bounds.right - 80, 0]
end

