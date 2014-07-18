require 'prawn'
require 'prawn/table'
require 'prawn/blank'
#Prawn::Document.generate("/tmp/prawn=#{Time.now.to_i}.pdf", :background => bg) { move_down 100; text "HI THERE!!" }

#tempfile = Tempfile.new(["praw-doc-#{Time.now.to_i}","pdf"])
#tempfile.write(CandidatePetitionFormReportPdf.new(Voter.limit(5)).render.force_encoding("UTF-8"))

class CandidatePetitionFormReportPdf < Prawn::Document
  # Often-Used Constants
  TABLE_ROW_COLORS = ["FFFFFF","FFFFFF"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :none
  CHECKBOX = "\u2610"
  CHECKED_CHECKBOX = "\u2611" # checked
  EXED_CHECKBOX = "\u2612" # x'd
  
  def initialize(voters = [], default_prawn_options = {})
    super(default_prawn_options.merge(margin: 20))
    #super(page_layout: :landscape, margin: 25)
    @voters = voters

    # Write Header
    header

    # Write in 5 signature blocks
    #build_signatures
    
    # Write Footer
    repeat :all do
      footer
    end
  end

private

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
      horizontal_rule
    end
    move_down 3
    formatted_text [ { text: "Please Note: ", size: 9, styles: [:bold, :italic] },
                     { text: "The information you provide on this petition is public information and may be used to change your voter registration address.", size: 9, styles: [:italic] }    
    ], align: :justify
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

  def footer
    bounding_box [bounds.left, bounds.bottom + 86], width: 262, valign: :bottom do
      font_size 8
      text "_________________________________________________________", align: :left
      text "Individual Cirulator's printed or typed name", align: :left
      move_down 3
      text "_________________________________________________________", align: :left
      text "Residence Address", align: :left
      move_down 3
      text "_________________________________________________________", align: :left
      text "City                                                                  State                   Zip", align: :left
      move_down 3
      text "_________________________________________________________", align: :left
      text "Telephone (including area code)", align: :left
      stroke do
        vertical_line 0, bounds.top, at: bounds.right
      end
    end

    bounding_box [bounds.left + 265, bounds.bottom + 120], width: 280 do
      formatted_text [ { text: "Circulator's Affidavit ", styles: [:bold], size: 10 },
        { text: "Under penalties of perjury, I swear (or affirm) that: (a) I was at least 18 years old when each signature was obtained; (b) the information given to the left identifiy me is true and correct; (c) I personally observed each signer as he or she signed this page; and (d) to the best of my knowledge and belief; (i) all signatures on this page are genuine; and (ii) all signers are registered voters of Maryland.", size: 9 }
      ], align: :justify, leading: -1
      text "(Sign and Date when signature collection is completed)", style: :italic
      text "_______________________________________________________________", align: :left
      text "Circulator's Signature                                        Date (mm/dd/yy)", align: :left
    end
  end
end
