require 'prawn'
require 'prawn/table'
#Prawn::Document.generate("/tmp/prawn=#{Time.now.to_i}.pdf", :background => bg) { move_down 100; text "HI THERE!!" }

class CandidatePetitionFormReportPdf < Prawn::Document #(:template => "#{Rails.root}/public/pdfs/candidate_petition_form_FINAL.pdf")

  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","FFFFFF"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :none

  def initialize(default_prawn_options = {}, voters = [])
    bg = "#{Rails.root}/public/pdfs/candidate_petition_form_FINAL.png"
    default_prawn_options.merge!(:background => bg)
    super(default_prawn_options)
    #super(page_layout: :landscape, margin: 25)
    @voters = voters

    build_signatures
  end

private

  def build_signatures
    move_down 200
    if signatures_table_data.empty?
      text ""
    else
      table signatures_table_data,
        header: false,
        width: bounds.width,
        #column_widths: [100,100,100,100,30,30,30],
        row_colors: TABLE_ROW_COLORS,
        cell_style: { size: TABLE_FONT_SIZE }
    end
  end

  def signatures_table_data 
    @signatures_table_data ||= @voters.all.map { |v| [v.first_name, v.middle_name, v.last_name,"", (v.dob.month rescue nil),(v.dob.day rescue nil),(v.dob.year rescue nil)] }
  end

end
