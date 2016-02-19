class ReportsController < AuthenticatedUsersController
  before_filter :set_order

  def candidate_petition_form
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CandidatePetitionFormReportPdf.new(@voters)
        send_data pdf.render, filename: "candidate_petition_form_#{Time.now.to_i}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end
  
private

  def set_order
    @order = Order.find(params[:order_id].to_i)
  end
end
