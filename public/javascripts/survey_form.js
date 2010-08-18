
function add_survey_question() {
	jQuery.get('/admin/survey_questions/new.js', function(data) { });
}

function add_survey_answer() {
	jQuery.get('/admin/survey_answers/new.js', function(data) { });
}

$(document).ready(function() {

});



