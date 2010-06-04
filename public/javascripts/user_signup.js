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

	function CountyOptionsPopulate() {
	$('#user_organization_attributes_political_campaigns_attributes_0_council_district_id').children().remove();

$('#user_organization_attributes_political_campaigns_attributes_0_council_district_id').ajaxAddOption('/council_districts_populate/'+this.value+'.json', {}, false);
	
	}

	function StateOptionsPopulate() {
$('#user_organization_attributes_political_campaigns_attributes_0_congressional_district_id').children().remove();
$('#user_organization_attributes_political_campaigns_attributes_0_senate_district_id').children().remove();
$('#user_organization_attributes_political_campaigns_attributes_0_house_district_id').children().remove();
$('#user_organization_attributes_political_campaigns_attributes_0_county_id').children().remove();
$('#user_organization_attributes_political_campaigns_attributes_0_city_id').children().remove();

$('#user_organization_attributes_political_campaigns_attributes_0_congressional_district_id').ajaxAddOption('/cd_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_senate_district_id').ajaxAddOption('/sd_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_house_district_id').ajaxAddOption('/hd_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_county_id').ajaxAddOption('/counties_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_city_id').ajaxAddOption('/cities_populate/'+this.value+'.json', {}, false);

$('#user_organization_attributes_political_campaigns_attributes_0_city_text').autocomplete({ url: '/cities_populate/'+this.value+'.js', minChars: 3});

	}

	function CountyOptionsShowHide() {
		$('div#notcountywide').hide();

		if (this.value == "false") {
			$('div#notcountywide').css('display','inline');
		}
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
		$('div#countyseat').hide();
		$('div#muniseat').hide();
		
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
	} else if (this.value == "StateCampaign") {
$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').addOption(stOptions, false);
		askSeat = true;
	} else if (this.value == "CountyCampaign") {
		$('div#countyseat').css('display','inline');
	} else if (this.value == "MunicipalCampaign") {
		$('div#muniseat').css('display','inline');
	}
	
	if (askSeat) {
		$('div#seattype').css('display','inline');
	}
	
	}

$('#user_organization_attributes_political_campaigns_attributes_0_state_id').bind("change", StateOptionsPopulate);
	$('#user_organization_attributes_political_campaigns_attributes_0_type').bind("change", SeatPopulate);

$('#user_organization_attributes_political_campaigns_attributes_0_seat_type').bind("change", StateOptionsShowHide);

$('#user_organization_attributes_political_campaigns_attributes_0_county_id').bind("change", CountyOptionsPopulate);

$('#user_organization_attributes_political_campaigns_attributes_0_countywide_true').bind("click", CountyOptionsShowHide);

$('#user_organization_attributes_political_campaigns_attributes_0_countywide_false').bind("click", CountyOptionsShowHide);

});



