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
	
$(document).ready(function() {

	//submit the form via ajax request.
	$('#new_walksheet').submitWithAjax();
	
  $('#accordions').accordion();

$('#walksheet_voting_history_type_filter_attributes_string_val').bind('change', voting_history_type_filter_changed);

$('#walksheet_voting_history_type_filter_attributes_int_val').bind('change', voting_history_type_filter_int_val_changed);

$('#walksheet_age_filter_attributes_int_val').bind('change', age_filter_changed);

$('#walksheet_age_filter_attributes_max_int_val').bind('change', age_filter_changed);

$('#walksheet_sex_filter_attributes_string_val_f').bind('click', sex_filter_changed);

$('#walksheet_sex_filter_attributes_string_val_m').bind('click', sex_filter_changed);

$('#walksheet_sex_filter_attributes_string_val_a').bind('click', sex_filter_changed);

$('div#party_group').each(function () {
	$(this).children('input:checkbox').bind('click', party_filter_changed);
});

$('table#voting_history_group').each(function () {
	$(this).children('tbody').each(function() {
		$(this).children('tr').each(function() {
			$(this).children('td').each(function() {
				$(this).children('input:checkbox').bind('click', voting_history_filter_changed);
			});
		});
	});
});

});



