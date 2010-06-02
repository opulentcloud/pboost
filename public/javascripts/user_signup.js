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
});

//	function SeatChangeReset() {
//			$('div#fed_seats').hide();

//			if (this.value == 'FederalCampaign') { 
//				$('div#fed_seats').css('display','inline'); 
//			}			
//		}


