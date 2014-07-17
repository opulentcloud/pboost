require 'prawn'
require 'prawn/table'
#Prawn::Document.generate("/tmp/prawn=#{Time.now.to_i}.pdf", :background => bg) { move_down 100; text "HI THERE!!" }

class ReportTest

  def initialize
  end

  def self.generate(voters)
    bg = "#{Rails.root}/public/pdfs/candidate_petition_form_FINAL.png"

    Prawn::Document.generate(Tempfile.new(["prawn-doc",".pdf"], :bin_mode => true),
      :background => bg) do
      
    end
  end
end
