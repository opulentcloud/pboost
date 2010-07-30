var polygon_index = -1;
var overlays = new Array();
var colors = ["red","blue","orange","purple","yellow","green","gray","pink","cyan","navy"];
var center_point;
var clusterer;

function build_vertices(polygon){
	v = '';
	for(var i = 0; i < polygon.getVertexCount(); i++) {
		v += '[' + polygon.getVertex(i).toUrlValue() + '],';
	}
	v = '[' + v.substring(0, v.length - 1) + ']';
	return v;
}

function set_map_values() {
	$("#sms_list_gis_region_attributes_name").val($("#sms_list_name").val() + ' Routes');
	set_map_vertices();
	return true;
}

function set_map_vertices() {
	vertices = new Array();
	vtext = '';
	for(var x=0;x<overlays.length;x++) {
		vertices.push(build_vertices(overlays[x]));
		vtext += vertices[x]+',';
	}
	vtext = "[" + vtext.substr(0, vtext.length-1) + "]"
	$("#sms_list_gis_region_attributes_vertices").val(vtext);
}

function PrecinctOptionsPopulate() {
	$('#sms_list_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#sms_list_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/cd/'+q_val+'.json', {}, false);

}

function PrecinctOptionsPopulate2() {
	$('#sms_list_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#sms_list_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/mcomm_dist_code/'+q_val+'.json', {}, false);

}

function SchedulingOptionsShowHide() {
	$('div#schedule').hide();

	if (this.checked) {
		$('div#schedule').show();
	}
}

$(document).ready(function() {

	$('h3#geo').click(function(event) {
		event.preventDefault();
		$('#geo_box').slideToggle('fast', function() {
			//animation complete.
		});
	});

	$('h3#dem').click(function(event) {
		event.preventDefault();
		$('#dem_box').slideToggle('fast', function() {
			//animation complete.
		});
	});

	$('h3#vh').click(function(event) {
		event.preventDefault();
		$('#vh_box').slideToggle('fast', function() {
			//animation complete.
		});
	});

	//submit the form via ajax request.
	$('#new_sms_list').submitWithAjax();

$('#sms_list_municipal_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate2);

$('#sms_list_council_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate);

$('#sms_list_voting_history_type_filter_attributes_string_val').bind('change', voting_history_type_filter_changed);

$('#sms_list_voting_history_type_filter_attributes_int_val').bind('change', voting_history_type_filter_int_val_changed);

$('#sms_list_age_filter_attributes_int_val').bind('change', age_filter_changed);

$('#sms_list_age_filter_attributes_max_int_val').bind('change', age_filter_changed);

$('div#sex_group').each(function () {
	$(this).children('p').each(function () {
		$(this).children('input:radio').bind('click', sex_filter_changed);
	});	
});

$('div#party_group').each(function () {
	$(this).children('p').each(function () {
		$(this).children('input:checkbox').bind('click', party_filter_changed);
	});
});

$('table#voting_history_group').each(function () {
	$(this).children('tbody').each(function() {
		$(this).children('tr').bind('click', voting_history_filter_changed);
	});
});

$('#sms_list_schedule').bind("click", SchedulingOptionsShowHide);

$('#sms_list_sms_text').keypress(function(event) {
	cnt = parseInt($('span#chars_used').text())

	if (event.which != 8 && cnt >= 160) {
		alert('You have reached the length limit for this message.');
		event.preventDefault();
		return;
	}

	if (event.which == 8 && cnt>0) { 
		cnt--; 
		current_text = $('#sms_list_sms_text').val();
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



