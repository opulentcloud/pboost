class HelloReport < Prawn::Document
	
	def to_pdf
=begin
		table [
			['mark','wilson']
		],
		:font_size => 10,
		:horizontal_padding => 2,
		:vertical_padding => 2,
		:border_width => 1,
		:position => :center,
		:headers => ['First Name','Last Name'],
		:align => {1 => :center},
		:align_headers => :center
=end		
		#font 'Times-Roman'
		#stroke_line [bounds.left, bounds.top],
#										[bounds.right, bounds.top]
		#text content, :size => 10
		repeat(:all) do
			text "Walk Sheet - #{@walksheet.political_campaign.candidate_name}", :font_size => 14
		end
		200.times do |x|
			text "#{x} - Hello World"
		end
		
		number_pages "<page> of <total>", [bounds.right - 50, 0]
		render
	end
end
