
class WalksheetReport

	@@Widths = [202,32,32,40,50,34,40,80,60,50,50,50] #712 width
	@@Headers = ['Address / Voter Name', 'Sex', 'Age', 'Party', 'Quality', 'New', 'Ethn', 'State ID', 'Y / N / U', 'AB','Sign','Trans']

	def self.build(walksheet)
		if walksheet.gis_region && !walksheet.gis_region.geom2.nil?
			walksheet.gis_region.geom2.each_with_index do |poly, index|
				#build a pdf for each route.
				walksheet.file_name = "docs/walksheet_route_#{index}_#{walksheet.id}.pdf"
				walksheet.route_index = index
				WalksheetReport.generate_pdf(walksheet)
			end
		else
			walksheet.file_name = "docs/walksheet_#{walksheet.id}.pdf"
			walksheet.route_index = nil
			WalksheetReport.generate_pdf(walksheet) #only 1 route
		end
	end

	def self.generate_pdf(walksheet)
		 
		Prawn::Document.generate("#{walksheet.file_name}", :page_layout => :landscape, :page_size => [612, 792], :left_margin => 10) do

			self.font 'Helvetica'
			self.font_size = 9
			
			if walksheet.route_index.nil?			
				left_header = "#{walksheet.name}"
			else
				left_header = "#{walksheet.name} - Route #{walksheet.route_index+1}"
			end

			if walksheet.route_index.nil?
				right_header = "# Of Voters: #{walksheet.voters.count}"
			else
				right_header = "# Of Voters: #{walksheet.voters_by_route.count}"
			end

			location_header = case walksheet.political_campaign.class.to_s
				when 'MunicipalCampaign' then
					"#{walksheet.political_campaign.city.name}, #{walksheet.political_campaign.state.name}"
				when 'CountyCampaign' then
					"#{walksheet.political_campaign.county.name}, #{walksheet.political_campaign.state.name}"
				else
					"#{walksheet.political_campaign.state.name}"				
			end					

			header_row = [['',"Walk Sheet - #{walksheet.political_campaign.candidate_name}",''],["#{left_header}","#{location_header}","#{right_header}"]]

			repeat(:all) do
				table(header_row)	do |t|
					t.column_widths = [(bounds.width.to_f * 0.2),(bounds.width.to_f * 0.60), (bounds.width.to_f * 0.2)]
					t.cells.style :borders => []
					t.column(0).align = :left
					t.column(0).style :size => 10, :style => :bold
					t.column(1).align = :center
					t.column(1).style :size => 16, :style => :bold
					t.column(2).align = :right
					t.column(2).style :size => 10, :style => :bold
					t.rows(1).columns(1).style :size => 14
				end
								
				move_down(5)
			end

			head = make_table([@@Headers], :column_widths => @@Widths) do |t|
				t.rows(0).align = :center
				t.rows(0).style(:style => :bold)
			end

			def row(address, voter)
				#debugger
				rows = [[address,'','','','','','','','','','','']]
				rows += voter.map { |v| [v[0],v[1],v[2],v[3],v[4],'','',v[5],'Y / N / U','Yes | No','Yes | No','Yes | No'] }

				# Address goes on the first line.
				#rows[0][0] = address

				# Due and Balance go on the last line.
				#rows[-1][1] = sex
				#rows[-1][2] = age

				# Return a Prawn::Table object to be used as a subtable.
				make_table(rows) do |t|
				  t.column_widths = @@Widths
				  t.cells.style :borders => [], :padding => 2
					t.rows(0).align = :left
					t.rows(0).style :style => :bold
					t.rows(1..rows.size).align = :center
				  t.columns(1..rows.size).align = :center
				  t.style t.rows(1..rows.size).columns(0), :padding => [0,0,0,40], :align => :left
				  t.rows(rows.size-1).style :borders => [:bottom]
				end

			end

			data = []
			voter = nil
			voters = nil
			current_address = nil

			walksheet.voters_by_route('false').map do |a|
					voter = [a.printable_name, a.sex, a.age.to_s, a.party, a.quality.to_s, a.state_file_id.to_s]
					current_address = a.address.full_street_address if current_address.nil?					
					if current_address == a.address.full_street_address
						if voters.nil?
							voters = [voter]
						else
							voters += [voter]
						end
					else
						data << row(current_address.upcase, voters)
						voters = [voter]
						current_address = a.address.full_street_address
					end
			end
			#print the last row
			if current_address
				data << row(current_address.upcase, voters)
			end

			data2 = []
			voter = nil
			voters = nil
			current_address2 = nil

			#now build all odd addresses
			walksheet.voters_by_route('true').map do |a|
					voter = [a.printable_name, a.sex, a.age.to_s, a.party, a.quality.to_s, a.state_file_id.to_s]
					current_address2 = a.address.full_street_address if current_address2.nil?					
					if current_address2 == a.address.full_street_address
						if voters.nil?
							voters = [voter]
						else
							voters += [voter]
						end
					else
						data2 << row(current_address2.upcase, voters)
						voters = [voter]
						current_address2 = a.address.full_street_address
					end
			end
			#print the last row
			if current_address2
				data2 << row(current_address2.upcase, voters)
			end

			bounding_box [30,cursor], :width => 1200 do
				# Wrap head and each data element in an Array -- the outer table has only one
				# column.
					table([[head], *(data.map{|d| [d]})], :header => true,
								:row_colors => %w[ffffff ffffff]) do
							row(0).style :background_color => 'ffffff', :text_color => '000000'
						cells.style :borders => []
					end
					
					start_new_page

					table([[head], *(data2.map{|d| [d]})], :header => true,
								:row_colors => %w[ffffff ffffff]) do
							row(0).style :background_color => 'ffffff', :text_color => '000000'
						cells.style :borders => []
					end

			end

			font('Helvetica', :style => :italic, :size => 8) do
				number_pages "PoliticalBoost.com Page <page> of <total>", [bounds.right - 100, 0]
			end

		end
	end

end

