//JQuery.ajaxSetup({
//	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
//});
	
$(document).ready(function() {

	function xvalShowHide() {
		$('span#xval').hide();

		if (this.value == "At Least") {
			$('span#xval').css('display','inline');
		} else if (this.value == "Exactly") {
				$('span#xval').css('display','inline');
		} else if (this.value == "No More Than") {
				$('span#xval').css('display','inline');
		}
	}

$('#walksheet_voting_history_type_filter_attributes_string_val').bind("change", xvalShowHide);

});



