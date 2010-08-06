function SchedulingOptionsShow() {
	$('div#schedule').show();
}

function AMFileShowHide() {
	$('div#answer_machine_file').hide();

	if (!this.checked) {
		$('div#answer_machine_file').show();
	}
}

$(document).ready(function() {

$('#robocall_campaign_single_sound_file').bind("click", AMFileShowHide);

});



