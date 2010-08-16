class SurveyJob < Struct.new(:survey_id)
	def perform
		Survey.populate(survey_id)
	end
end
