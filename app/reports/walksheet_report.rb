
class WalksheetReport

	@@Widths = [340,200,200] #portait is 540 width
	@@Headers = ["Patient Name", "Patient Portion Due", "Balance"]

	def self.build(walksheet)
 
		Prawn::Document.generate("docs/walksheet_#{walksheet.id}.pdf", :page_layout => :landscape, :page_size => 'A4') do 

			font_size = 9
			font 'Helvetica'

			left_header = "Precinct XXX"
			right_header = "# Of Voters: #{walksheet.voters.count}"

			header_row = ["#{left_header}","Walk Sheet - #{walksheet.political_campaign.candidate_name}","#{right_header}"]

			repeat(:all) do
				table([header_row])	do |t|
					t.column_widths = [(bounds.width.to_f * 0.2),(bounds.width.to_f * 0.58), (bounds.width.to_f * 0.2)]
					t.cells.style :borders => []
					t.column(0).align = :left
					t.column(0).style :size => 14, :style => :bold
					t.column(1).align = :center
					t.column(1).style :size => 20, :style => :bold
					t.column(2).align = :right
					t.column(2).style :size => 14, :style => :bold
				end

				font('Helvetica', :style => :bold, :size => 16) do
					text "#{walksheet.political_campaign.city.name}, #{walksheet.political_campaign.state.name}", :align => :center
				end
								
				move_down(5)
			end

			head = make_table([@@Headers], :column_widths => @@Widths)

			data = []

			def row(pt, charges, portion_due, balance)
				rows = charges.map { |c| ["", c[0], c[1]] }

				# Patient Name go on the first line.
				rows[0][0] = pt

				# Due and Balance go on the last line.
				rows[-1][1] = portion_due
				rows[-1][2] = balance

				# Return a Prawn::Table object to be used as a subtable.
				make_table(rows) do |t|
				  t.column_widths = @@Widths
				  t.cells.style :borders => [:left, :right], :padding => 2
				  t.columns(1..2).align = :right
				end

			end

			#data << row("", [["Balance Forward", ""]], "0.00", "0.00")
			50.times do
				data << row("John", [["Foo", "Bar"], 
				                                 ["Foo", "Bar"]], "5.00", "0.00")
			end

			bounding_box [30,cursor], :width => 800 do
				# Wrap head and each data element in an Array -- the outer table has only one
				# column.
					table([[head], *(data.map{|d| [d]})], :header => true,
								:row_colors => %w[cccccc ffffff]) do
							row(0).style :background_color => 'ffffff', :text_color => '000000'
						cells.style :borders => []
					end
			end

			font('Helvetica', :style => :italic, :size => 8) do
				number_pages "PoliticalBoost.com Page <page> of <total>", [bounds.right - 80, 0]
			end

		end
	end

end

