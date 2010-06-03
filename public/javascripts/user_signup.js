//JQuery.ajaxSetup({
//	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
//});
	
$(document).ready(function() {

	var haveSeat = false;

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

	function StateOptionsPopulate() {
$('#user_organization_attributes_political_campaigns_attributes_0_cd').children().remove();
$('#user_organization_attributes_political_campaigns_attributes_0_sd').children().remove();

$('#user_organization_attributes_political_campaigns_attributes_0_cd').ajaxAddOption('/cd_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_sd').ajaxAddOption('/sd_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_hd').ajaxAddOption('/hd_populate/'+this.value+'.json', {}, false);

	}

	function StateOptionsShowHide() {
		$('div#condist').hide();
		$('div#sendist').hide();
		$('div#hosdist').hide();

		if (this.value == "U.S. Congress") {
			$('div#condist').css('display','inline');
		} else if (this.value == "State Senate") {
				$('div#sendist').css('display','inline');
		} else if (this.value == "State House") {
				$('div#hosdist').css('display','inline');
		}
		
	}

	function SeatPopulate() {
		if (haveSeat) StateOptionsShowHide();
		haveSeat = true;
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

$('#user_organization_attributes_political_campaigns_attributes_0_state_abbrev').bind("change", StateOptionsPopulate);
	$('#user_organization_attributes_political_campaigns_attributes_0_type').bind("change", SeatPopulate);

$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').bind("change", StateOptionsShowHide);

});



