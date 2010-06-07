//JQuery.ajaxSetup({
//	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
//});
	
$(document).ready(function() {

	var haveSeat = false;
	var state_id;

	function CityOptionsPopulate() {
	$('#political_campaign_municipal_district_id').children().remove();

$('#political_campaign_municipal_district_id').ajaxAddOption('/municipal_districts_populate/'+state_id+'/'+this.value+'.json', {}, false);
	
	}

	function CountyOptionsPopulate() {
	$('#political_campaign_council_district_id').children().remove();

$('#political_campaign_council_district_id').ajaxAddOption('/council_districts_populate/'+this.value+'.json', {}, false);
	
	}

	function StateOptionsPopulate() {
		state_id = this.value;
$('#political_campaign_congressional_district_id').children().remove();
$('#political_campaign_senate_district_id').children().remove();
$('#political_campaign_house_district_id').children().remove();
$('#political_campaign_county_id').children().remove();
$('#political_campaign_city_id').children().remove();
$('#political_campaign_municipal_district_id').children().remove();

$('#political_campaign_congressional_district_id').ajaxAddOption('/cd_populate/'+this.value+'.json', {}, false);

$('#political_campaign_senate_district_id').ajaxAddOption('/sd_populate/'+this.value+'.json', {}, false);

$('#political_campaign_house_district_id').ajaxAddOption('/hd_populate/'+this.value+'.json', {}, false);

$('#political_campaign_county_id').ajaxAddOption('/counties_populate/'+this.value+'.json', {}, false);

$('#political_campaign_city_id').ajaxAddOption('/cities_populate/'+this.value+'.json', {}, false);

$('#political_campaign_city_text').autocomplete({ url: '/cities_populate/'+this.value+'.js', minChars: 3});

	}

	function CityOptionsShowHide() {
		$('div#notmuniwide').hide();

		if (this.value == "false") {
			$('div#notmuniwide').css('display','inline');
		}
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
		$('div#seattype2').hide();
		$('div#countyseat').hide();
		$('div#muniseat').hide();
		
$('#political_campaign_seat_type').children().remove();

		var fedOptions = { 
"" : "Please select",		
"U.S. Congress" : "U.S. Congress",
"U.S. Senate" : "U.S. Senate"
 }

		var stOptions = {
			"" : "Please select",
			"Attorney General" : "Attorney General",
			"Comptroller" : "Comptroller",
			"Governor" : "Governor",
			"Lt. Governor" : "Lt. Governor",
			"State House" :	"State House",
			"State Senate" : "State Senate"
		}

		var askSeat = false;

		if (this.value == "FederalCampaign") {
	$('#political_campaign_seat_type').addOption(fedOptions, false);
		askSeat = true;
	} else if (this.value == "StateCampaign") {
$('#political_campaign_seat_type').addOption(stOptions, false);
		askSeat = true;
	} else if (this.value == "CountyCampaign") {
		$('div#countyseat').css('display','inline');
	} else if (this.value == "MunicipalCampaign") {
		$('div#muniseat').css('display','inline');
	}
	
	if (askSeat) {
		$('div#seattype').css('display','inline');
	} else {
		$('div#seattype2').css('display','inline');
	}
	
	}

$('#political_campaign_state_id').bind("change", StateOptionsPopulate);
	$('#political_campaign_type').bind("change", SeatPopulate);

$('#political_campaign_seat_type').bind("change", StateOptionsShowHide);

$('#political_campaign_county_id').bind("change", CountyOptionsPopulate);

$('#political_campaign_countywide_true').bind("click", CountyOptionsShowHide);

$('#political_campaign_countywide_false').bind("click", CountyOptionsShowHide);

$('#political_campaign_city_text').bind("blur", CityOptionsPopulate);

$('#political_campaign_muniwide_true').bind("click", CityOptionsShowHide);

$('#political_campaign_muniwide_false').bind("click", CityOptionsShowHide);

});



