class SurveyAnswersController < ApplicationController
	before_filter :require_user
	filter_access_to :all
  ssl_required :new
  
  def new
		@survey_answer = SurveyAnswer.new
		@question_id = params[:qid].to_i
		@sequence = params[:seq].to_i
  
		respond_to do |format|
			format.html { redirect_to @survey_answer }
			format.js
		end
	end
end

