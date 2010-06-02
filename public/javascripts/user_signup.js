//JQuery.ajaxSetup({
//	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
//});
	
$(document).ready(function() {

	$("#new_user").formwizard({ 
	  //form wizard settings
	  historyEnabled : true, 
	  formPluginEnabled: true, 
	  validationEnabled : true,
	  focusFirstInput : true},
 {
   //validation settings
 },
 {
   // form plugin settings
	 success: function(data) {
	 	//$("#content_body").html(data);
	 },
	 dataType: 'script',
	 resetForm: false
 }
);

	function SeatChange() {
			$('div#fed_seats').hide();

			if (this.value == 'FederalCampaign') { 
				$('div#fed_seats').css('display','inline'); 
			}			
		}

	function SeatPopulate() {
		$('div#seattype').hide();
$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').children().remove();

		var fedOptions = { 
"" : "Please select",		
"U.S. Senate" : "U.S. Senate",
"U.S. Congress" : "U.S. Congress" }

		var stOptions = {
			"" : "Please select",
			"State Senate" : "State Senate",
			"State House" : "State House"
		}
		var askSeat = false;

		if (this.value == "FederalCampaign") {
	$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').addOption(fedOptions, false);
		askSeat = true;
	} else {
		if (this.value == "StateCampaign") {
$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').addOption(stOptions, false);
		askSeat = true;
		}
	}
	
	if (askSeat) {
		$('div#seattype').css('display','inline');
	}
	
	}
	$('#user_organization_attributes_political_campaigns_attributes_0_type').bind("change", SeatPopulate);

});



