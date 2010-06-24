
class WalksheetReport

	@@Widths = [50, 90, 170, 90, 90, 50] #portait is 540 width
	@@Headers = ["Date", "Patient Name", "Description", "Charges / Payments", 
				         "Patient Portion Due", "Balance"]

	def self.build(walksheet)
 
		Prawn::Document.generate("docs/walksheet_#{walksheet.id}.pdf", :page_layout => :landscape, :page_size => 'A4') do 

			self.font_size = 9

			repeat(:all) do
				font_size 20 do
					text "Walk Sheet - #{walksheet.political_campaign.candidate_name}", :style => :bold
				end
				font('Helvetica', :style => :bold, :size => 12) do
					text "Name of Walker:___________________________________                    Date Walked: ____________"
				end
			end

			head = make_table([@@Headers], :column_widths => @@Widths)

			data = []

			def row(date, pt, charges, portion_due, balance)
				rows = charges.map { |c| ["", "", c[0], c[1], "", ""] }

				# Date and Patient Name go on the first line.
				rows[0][0] = date
				rows[0][1] = pt

				# Due and Balance go on the last line.
				rows[-1][4] = portion_due
				rows[-1][5] = balance

				# Return a Prawn::Table object to be used as a subtable.
				make_table(rows) do |t|
				  t.column_widths = @@Widths
				  t.cells.style :borders => [:left, :right], :padding => 2
				  t.columns(4..5).align = :right
				end

			end

			data << row("1/1/2010", "", [["Balance Forward", ""]], "0.00", "0.00")
			50.times do
				data << row("1/1/2010", "John", [["Foo", "Bar"], 
				                                 ["Foo", "Bar"]], "5.00", "0.00")
			end


		if 1 == 0 #trying to nest in another header is not working
			# Wrap head and each data element in an Array -- the outer table has only one
			# column.
			vdata = [make_table([[head], *(data.map{|d| [d]})], :header => true,
				    :row_colors => %w[cccccc ffffff]) do
					row(0).style :background_color => 'ffffff', :text_color => '000000'
				cells.style :borders => []
			end]

			main_head = make_table([["Walksheet Header"]], :width => 540)

			table([[main_head], *(vdata.map{|d| [d]})], :column_widths => [540])
		else
			bounding_box [20,cursor], :width => 600 do
				# Wrap head and each data element in an Array -- the outer table has only one
				# column.
					table([[head], *(data.map{|d| [d]})], :header => true,
								:row_colors => %w[cccccc ffffff]) do
							row(0).style :background_color => 'ffffff', :text_color => '000000'
						cells.style :borders => []
					end
			end
		end

		end
	end

end

