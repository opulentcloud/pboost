function SchedulingOptionsShow() {
	$('div#schedule').show();
}

function calc_total_price() {
	if ($("#sms_campaign_contact_list_id").val() == '') {
		$("span#pricing").text("");
	} else {
		$("#pricing").text("calculating...");
		id = $("#sms_campaign_contact_list_id").val();
		jQuery.get('/customer/sms_campaign/get_price_sms.js?sms_list_id='+id +'', function(data) { } );
	}
}

$(document).ready(function() {

$('#sms_campaign_contact_list_id').bind("change", calc_total_price);

$('#sms_campaign_schedule').bind("click", SchedulingOptionsShow);

$('#sms_campaign_sms_text').keypress(function(event) {
	cnt = parseInt($('span#chars_used').text())

	if (event.which != 8 && cnt >= 160) {
		alert('You have reached the length limit for this message.');
		event.preventDefault();
		return;
	}

	if (event.which == 8 && cnt>0) { 
		cnt--; 
		current_text = $('#sms_campaign_sms_text').val();
		lc = current_text.substr(current_text.length-1,1);
		var re = /[~@#%+=/\\\r\n]/;
		if (re.test(lc) && cnt > 1) { cnt--; }
	}
	
	else if (event.which == 0) { } 
	else if (event.which == 13) { cnt+=2; }
	else if (event.which >= 32 && event.which <= 33) { cnt++; }
	else if (event.which == 35) { cnt+=2; }
	else if (event.which == 36) { cnt++; }
	else if (event.which == 37) { cnt+=2; }
	else if (event.which == 38) { cnt++; }
	else if (event.which >= 40 && event.which <= 41) { cnt++; }
	else if (event.which == 43) { cnt+=2; }
	else if (event.which >= 44 && event.which <= 46) { cnt++; }
	else if (event.which == 47) { cnt+=2; }
	else if (event.which >= 48 && event.which <= 59) { cnt++; }
	else if (event.which == 61) { cnt+=2; }
	else if (event.which == 63) { cnt++; }
	else if (event.which == 64) { cnt+=2; }
	else if (event.which >= 65 && event.which <= 90) { cnt++; }
	else if (event.which == 92) { cnt+=2; }
	else if (event.which == 95) { cnt++; }
	else if (event.which >= 97 && event.which <= 122) { cnt++; }
	else if (event.which == 126) { cnt+=2; }
	else {
		alert('This character is not allowed in an SMS message.')
		event.preventDefault();
		return;
	}

	$('span#chars_used').text(cnt);
});

});



