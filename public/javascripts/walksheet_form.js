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
	$("#walksheet_gis_region_attributes_name").val($("#walksheet_name").val() + ' Routes');
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
	$("#walksheet_gis_region_attributes_vertices").val(vtext);
}

function PrecinctOptionsPopulate() {
	$('#walksheet_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#walksheet_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/cd/'+q_val+'.json', {}, false);

}

function PrecinctOptionsPopulate2() {
	$('#walksheet_precinct_filter_attributes_string_val').children().remove();
	q_val = this.value;
	if (q_val == '') { q_val = 0; }
$('#walksheet_precinct_filter_attributes_string_val').ajaxAddOption('/precincts_populate/mcomm_dist_code/'+q_val+'.json', {}, false);

}
	
$(document).ready(function() {

	//submit the form via ajax request.
	$('#new_walksheet').submitWithAjax();
	
  $('#accordions').accordion();

$('#walksheet_municipal_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate2);

$('#walksheet_council_district_filter_attributes_string_val').bind("change", PrecinctOptionsPopulate);

$('#walksheet_voting_history_type_filter_attributes_string_val').bind('change', voting_history_type_filter_changed);

$('#walksheet_voting_history_type_filter_attributes_int_val').bind('change', voting_history_type_filter_int_val_changed);

$('#walksheet_age_filter_attributes_int_val').bind('change', age_filter_changed);

$('#walksheet_age_filter_attributes_max_int_val').bind('change', age_filter_changed);

$('div#sex_group').each(function () {
	$(this).children('input:radio').bind('click', sex_filter_changed);
});

$('div#party_group').each(function () {
	$(this).children('input:checkbox').bind('click', party_filter_changed);
});

$('table#voting_history_group').each(function () {
	$(this).children('tbody').each(function() {
		$(this).children('tr').bind('click', voting_history_filter_changed);
	});
});

});



