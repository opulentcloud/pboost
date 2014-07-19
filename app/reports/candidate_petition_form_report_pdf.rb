require 'prawn'
require 'prawn/table'
require 'prawn/blank'
#Prawn::Document.generate("/tmp/prawn=#{Time.now.to_i}.pdf", :background => bg) { move_down 100; text "HI THERE!!" }

#tempfile = Tempfile.new(["praw-doc-#{Time.now.to_i}","pdf"])
#tempfile.write(CandidatePetitionFormReportPdf.new(Voter.limit(5)).render.force_encoding("UTF-8"))

#voter_ids = Voter.limit(5).each_with_object([]) { |v,arr| arr << v.id }
#tempfile.write(CandidatePetitionFormReportPdf.new(Voter.where(id: voter_ids)).render.force_encoding("UTF-8"))

class CandidatePetitionFormReportPdf < Prawn::Document
  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","FFFFFF"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :none
  CHECKBOX = "\u2610"
  CHECKED_CHECKBOX = "\u2611" # checked
  EXED_CHECKBOX = "\u2612" # x'd
  
  def initialize(voter_ids, default_prawn_options = {})
    super(default_prawn_options.merge(margin: 20))
    #super(page_layout: :landscape, margin: 25)
    blank_voter = Voter.new
    blank_voter.build_address


    if 1 == 0 # batch ignores the ordering
      # Write in 5 signature blocks
      Voter.includes(:address).where(id: voter_ids).order("addresses.street_name, addresses.is_odd, addresses.street_no, addresses.apt_no").find_in_batches(batch_size: 5) do |batch|
        first = true
        start_new_page unless first == true
        first = false
        # Write Header
        header
        batch.each_with_index do |voter, index|
          signature_row(voter, index+1)
        end
        footer
      end
    else # manually doing 5 at a time
      index = -1
      # Write in 5 signature blocks
      Voter.includes(:address).where(id: voter_ids).order("addresses.street_name, addresses.is_odd, addresses.street_no, addresses.apt_no").each do |voter|
        index += 1
        if index == 1
          start_new_page 
          # Write Header
          header
        end          
        if index == 0
          # Write Header
          header
          index += 1 
        end
        signature_row(voter, index)
        if index == 5
          footer
          index = 0 
        end
      end

      # print any blank rows before footer if needed.
      while index < 5 do
        index += 1
        signature_row(blank_voter, index)
        if index == 5
          footer
        end
      end
    end
  end

private

  def signature_row(voter, row_number)
    stroke do
      self.line_width = 1
      horizontal_rule
    end
    move_down 4
    font_size(10) do
      text_box "First Name", kerning: false, at: [70, cursor]
      text_box "Middle Name", kerning: false, at: [169, cursor]
      text_box "Last Name", kerning: false, at: [279, cursor]
      text_box "Month", kerning: false, at: [427, cursor]
      text_box "Date", kerning: false, at: [479, cursor]
      text_box "Year", kerning: false, at: [524, cursor]
      move_down 14
      text_box "#{voter.first_name}", kerning: true, at: [70, cursor]
      text_box "#{voter.middle_name}", kerning: true, at: [169, cursor]
      text_box "#{voter.last_name}", kerning: true, at: [279, cursor]
      text_box "#{voter.dob.month.to_s.rjust(2, '0') rescue nil}", kerning: false, at: [427, cursor]
      text_box "#{voter.dob.day.to_s.rjust(2, '0') rescue nil}", kerning: false, at: [479, cursor]
      text_box "#{voter.dob.year rescue nil}", kerning: false, at: [524, cursor]
    end
    font_size 9
    bounding_box([bounds.left+25, cursor+6], at: 0, width: 28) do
      text "Print"
      move_up 2
      text "Name:"
    end    
    text_box "Birth Date:", kerning: false, at: [361, cursor+10]
    move_up 11
    font_size 10
    text "#{'_' * 98}", indent_paragraphs: 23
    text_box "Month", kerning: false, at: [427, cursor]
    text_box "Date", kerning: false, at: [479, cursor]
    text_box "Year", kerning: false, at: [524, cursor]
    move_down 12
    font_size(9) do
      text_box "Signature:", kerning: false, at: [bounds.left+25, cursor]
      bounding_box([361, cursor+6], at: 0, width: 42) do
        text "Date of"
        move_up 2
        text "Signature:"
      end    
    end
    move_up 10
    text "#{'_' * 98}", indent_paragraphs: 23
    font_size(10) do
      text_box "Street Number", kerning: false, at: [94, cursor]
      text_box "Street Name", kerning: false, at: [193, cursor]
      text_box "Apt. No.", kerning: false, at: [348, cursor]
      text_box "City or Town", kerning: false, at: [415, cursor]
      text_box "Zip", kerning: false, at: [530, cursor]
      move_down 15
      text_box "#{voter.address.full_street_number}", kerning: true, at: [94, cursor]
      text_box "#{voter.address.full_street_name}", kerning: true, at: [193, cursor]
      text_box "#{voter.address.full_apt_number}", kerning: true, at: [348, cursor]
      text_box "#{voter.address.city}", kerning: false, at: [415, cursor]
      text_box "#{voter.address.zip5}", kerning: false, at: [530, cursor]
    end
    move_up 1
    font_size 9
    bounding_box([bounds.left+25, cursor+13], at: 0, width: 45) do
      text "Maryland"
      move_up 2
      text "Residence"
      move_up 2
      text "Address:"
    end    
    stroke do
      self.line_width = 3
      horizontal_rule
      self.line_width = 1
      vertical_line cursor, cursor + 85, at: bounds.right
    end
    bounding_box([bounds.left, cursor+85], at: 0, width: 23, height: 85) do
      move_down 34
      text "#{row_number}", size: 15, style: :bold, indent_paragraphs: 3
      #transparent(0.5) { stroke_bounds }
      stroke do
        self.line_width = 8
        vertical_line 0, 85, at: bounds.right - 4
      end
    end
    move_down 1
  end

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

  def header
    text "State of Maryland - General Election Candidate Nomination Petition", size: 13, style: :bold, font: "Arial", align: :center
    text "We, the undersigned voters of ___________________________ County or     Baltimore City, hereby nominate the candidate(s) named below to appear on the General Election ballot.", size: 11, font: "Verdana", align: :left
    checkbox(name: "cb1", at: [368,727], checked: false)

    bounding_box [285, 710], width: 285 do
      formatted_text [ { text: "NOTICE TO SIGNERS:  Sign and print your name (1)  as  it  appears  on  the  voter registration list, OR  (2) your surname of registration AND at least one full given name AND the initial of any other names. ", size: 12, styles: [:bold] }, 
        { text: "Please print or type all information other than your signature. Post Office Box addresses are not generally accepted as valid. By signing this petition, you  agree  that  the  aformentioned candidate(s) should be placed on the ballot for the office indicated and that, to the best of your knowledge, you are registered to vote in Maryland and are eligible to have your signature counted for this petition.", size: 12 }
      ], align: :justify, leading: -2
      text "SBE 6-201-2C  (Rev 7-2011)", size: 8, align: :right
      stroke do
        self.line_width = 1
        vertical_line 3, 155, at: -3
      end
    end
    
    bounding_box [0, 710], width: 280 do
      font_size 11
      text "Candidate Information:", style: :bold, align: :left
      text "Party Affiliation: ________________________________", align: :left
      move_down 7
      font_size 10
      draw_text "(not a recognized party in Maryland)", at: [cursor+95, cursor]
      move_down 4
      font_size 11
      text "or check for      Unaffiliated", align: :left
      checkbox(name: "cb2", at: [62,4], checked: false)
      move_down 6
      font_size 10
      text "Name: ____________________________________________", align: :left
      move_down 6
      text "Address: __________________________________________", align: :left
      move_down 6
      text "Office and District: ___________________________________", align: :left
      move_down 3
      font_size 11
      text "If Applicable, Lt. Governor Information:", style: :bold, align: :left
      move_down 4
      font_size 10
      text "Name: ____________________________________________", align: :left
      move_down 6
      text "Address: __________________________________________", align: :left
    end
    stroke do
      self.line_width = 1    
      horizontal_rule
    end
    move_down 3
    formatted_text [ { text: "Please Note: ", size: 9, styles: [:bold, :italic] },
                     { text: "The information you provide on this petition is public information and may be used to change your voter registration address.", size: 9, styles: [:italic] }    
    ], align: :justify
  end

  def footer
    bounding_box [bounds.left, bounds.bottom + 93], width: 262 do
      font_size 8
      move_down 3
      text "_________________________________________________________", align: :left
      text "Individual Cirulator's printed or typed name", align: :left
      move_down 3
      text "_________________________________________________________", align: :left
      text "Residence Address", align: :left
      move_down 4
      text "_________________________________________________________", align: :left
      text "City                                                                  State                   Zip", align: :left
      move_down 5
      text "_________________________________________________________", align: :left
      text "Telephone (including area code)", align: :left
      stroke do
        self.line_width = 1
        vertical_line 0, bounds.top, at: bounds.right
      end
    end

    bounding_box [bounds.left + 265, bounds.bottom + 93], width: 290 do
      formatted_text [ { text: "Circulator's Affidavit ", styles: [:bold], size: 9 },
        { text: "Under penalties of perjury, I swear (or affirm) that: (a) I was at least 18 years old when each signature was obtained; (b) the information given to the left identifiying me is true and correct; (c) I personally observed each signer as he or she signed this page; and (d) to the best of my knowledge and belief; (i) all signatures on this page are genuine; and (ii) all signers are registered voters of Maryland.", size: 9 }
      ], align: :justify, leading: -1
      text "(Sign and Date when signature collection is completed)", style: :italic
      move_down 5
      text "_________________________________________________________________", align: :left
      text "Circulator's Signature                                                      Date (mm/dd/yy)", align: :left, size: 9
    end
  end
end
