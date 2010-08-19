
var q;
var a;

$(document).ready(function() {
	q = -1;
	a = -1;
});

function add_survey_question() {
	q++;
	jQuery.get('/admin/survey_questions/new.js?seq='+q+'', function(data) { });
}

function add_survey_answer(qstn) {
	a++;
	jQuery.get('/admin/survey_answers/new.js?qid='+qstn+'&seq='+a+'', function(data) { });
}



