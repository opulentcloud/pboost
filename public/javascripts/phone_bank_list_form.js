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
	$("#phone_bank_list_gis_region_attributes_name").val($("#phone_bank_list_name").val() + ' Routes');
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
	$("#phone_bank_list_gis_region_attributes_vertices").val(vtext);
}

function PrecinctOptionsPopulate() {
	$('#phone_bank_list_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#phone_bank_list_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/cd/'+q_val+'.json', {}, false);

}

function PrecinctOptionsPopulate2() {
	$('#phone_bank_list_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#phone_bank_list_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/mcomm_dist_code/'+q_val+'.json', {}, false);

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
	$('#new_phone_bank_list').submitWithAjax();

$('#phone_bank_list_municipal_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate2);

$('#phone_bank_list_council_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate);

$('#phone_bank_list_voting_history_type_filter_attributes_string_val').bind('change', voting_history_type_filter_changed);

$('#phone_bank_list_voting_history_type_filter_attributes_int_val').bind('change', voting_history_type_filter_int_val_changed);

$('#phone_bank_list_age_filter_attributes_int_val').bind('change', age_filter_changed);

$('#phone_bank_list_age_filter_attributes_max_int_val').bind('change', age_filter_changed);

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

});



