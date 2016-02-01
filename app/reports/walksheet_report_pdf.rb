require 'prawn'
require 'prawn/table'
require 'prawn/blank'
#Prawn::Document.generate("/tmp/prawn=#{Time.now.to_i}.pdf", :background => bg) { move_down 100; text "HI THERE!!" }

#tempfile = Tempfile.new(["praw-doc-#{Time.now.to_i}","pdf"])
#tempfile.write(CandidatePetitionFormReportPdf.new(Voter.limit(5)).render.force_encoding("UTF-8"))

#voter_ids = Voter.limit(5).each_with_object([]) { |v,arr| arr << v.id }
#tempfile.write(CandidatePetitionFormReportPdf.new(Voter.where(id: voter_ids)).render.force_encoding("UTF-8"))

=begin
We could have a section that has 'Other Household Voters' that just has their names and birthdate

Voter Name, DOB, Address, Additional HH Voters - and a section where the canvasser can select dispositions of the canvass - like checkboxes next to some options
(i.e. 'Was Home', 'Not Home', 'Dropped Literature', 'Supporter', 'Non-Supporter', 'Undecided', 'Wants Yard Sign')
=end

class WalksheetReportPdf < Prawn::Document
  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","FFFFFF"]
  TABLE_FONT_SIZE = 8
  TABLE_BORDER_STYLE = :none # :grid
  CHECKBOX = "\u2610"
  CHECKED_CHECKBOX = "\u2611" # checked
  EXED_CHECKBOX = "\u2612" # x'd

	@@Widths = [160, 160, 55, 160, 35, 50, 50, 35]
  @@Headers = ['Address', 'Voter Name', 'DOB', 'Additional Voters', 'Home?', 'Dropped Literature?', 'Supporter?', 'Wants Yard Sign?']

  def initialize(voter_ids, default_prawn_options = {})
    @voter_ids = voter_ids
#    super(page_layout: :landscape, left_margin: 50, right_margin: 50, bottom_margin: 25, top_margin: 25)
    super(default_prawn_options.merge(page_layout: :landscape, left_margin: 25, right_margin: 25))

    repeat(:all) do
      bounding_box([0, bounds.top], width: bounds.width) do
        header 'Walk-Sheet', Time.zone.now.strftime("%m/%d/%Y %I:%M %p")
      end
    end
    display_voters_table(:even)
    start_new_page
    display_voters_table(:odd)
    # display_total
    number_pages "PoliticalBoost.com Page <page> of <total>", { at: [bounds.right - 250, 0],
      #width: 250,
      align: :right,
      start_count_at: 1,
      color: "333333" }
  end

  def header(title=nil, sub_title=nil)
    # image "#{Rails.root}/public/assets/images/#{ENV['LOGO_IMAGE']}", height: 30 #, at: [0, cursor]
    text title, size: 18, style: :bold, align: :center if title.present?
    text sub_title, size: 14, style: :bold_italic, align: :center if sub_title.present?
    move_down 45
    #text_box "Statement ##{@statement_number}\nDate Range: #{@start_date} - #{@end_date}", size: 18, font: "Helvetica", align: :right
  end

  def footer
  end

  private

  def display_total
    move_down 10

    table_data = ["Total Amount: ", "$#{sprintf("%.2f",@orders.map { |order| order[:amount] }.sum).gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')}"]
    table([[],table_data],
      header: false,
      position: :right,
      row_colors: TABLE_ROW_COLORS,
      cell_style: { size: 12, font_style: :bold }) do
        column(0).style align: :right, border_right_width: 0
        column(1).style border_left_width: 0
        row(0).style align: :center
    end
  end

  def display_voters_table(street_side)
    table_headers = @@Headers
    bounding_box([0, bounds.top-45], width: bounds.width) do
      if voters_table_data(street_side).empty?
        text "No #{street_side} addresses found."
      else
        table(voters_table_data(street_side).unshift(table_headers),
          header: true,
          #width: 739, #bounds.width,
          width: @@Widths.sum, # 692,
          position: :center,
          column_widths: @@Widths,
          row_colors: TABLE_ROW_COLORS,
          cell_style: { size: TABLE_FONT_SIZE }) do
            column(0).style align: :left
            column(1).style align: :left
            column(2).style align: :center
            column(3).style align: :left
            column(4).style align: :center
            column(5).style align: :center
            column(6).style align: :center
            column(7).style align: :center
            row(0).style align: :center
        end
      end
    end
  end

  def voters_table_data(street_side)
    @voters = Voter.select("(REGEXP_REPLACE(TRIM(CONCAT(addresses.street_no, ' ', addresses.street_no_half, ' ', addresses.street_prefix, ' ', addresses.street_name, ' ', addresses.street_type, ' ', addresses.street_suffix, ' ', addresses.apt_type, ' ', addresses.apt_no)), '\s+', ' ', 'g')) AS full_street_address, (REGEXP_REPLACE(TRIM(CONCAT(voters.last_name, ', ', voters.first_name, ' ', voters.middle_name)), '\s+', ' ', 'g')) AS printable_name, (SELECT name_list FROM (SELECT address_id AS voter_address_id, string_agg(REGEXP_REPLACE(TRIM(CONCAT(v3.last_name, ', ', v3.first_name, ' ', v3.middle_name, ' ', to_char(v3.dob, 'MM/DD/YYYY'))), ' +', ' ', 'g'), ', ') AS name_list FROM voters v3 INNER JOIN addresses a3 ON a3.id = v3.address_id WHERE v3.id IN (#{@voter_ids.join(',')}) AND v3.dob > (SELECT MIN(v2.dob) FROM voters v2 WHERE v2.address_id = a3.id AND v2.id IN (#{@voter_ids.join(',')})) GROUP BY v3.address_id) as voters_names WHERE voter_address_id = addresses.id), voters.dob, addresses.street_name, addresses.street_type, addresses.is_odd, addresses.street_no, addresses.apt_no, voters.last_name").joins(:address).where(id: @voter_ids).where("addresses.is_odd = ?", street_side == :odd).where("voters.dob = (SELECT MIN(v2.dob) FROM voters as v2 WHERE v2.address_id = addresses.id AND v2.id IN (?))", @voter_ids).order("addresses.street_name, addresses.street_type, addresses.is_odd, addresses.street_no::int, addresses.apt_no, voters.dob")
    voter_rows(@voters)
  end

  def voter_rows(voters)
    voters_arr = []
    voters.each do |voter|
      voters_arr << [voter['full_street_address'], voter['printable_name'], (voter.dob.strftime("%m/%d/%Y") rescue ''), voter['name_list'].to_s.gsub("#{voter.last_name}, ", ''), 'Y / N', 'Y / N', 'Y / N / U', 'Y / N']
    end
    voters_arr
  end
end
