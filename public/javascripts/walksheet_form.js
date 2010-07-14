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

	//$('#new_walksheet').ajaxForm(function() {
		//submitted the form via ajax.
	//});

  $('#accordions').accordion();

	function xvalShowHide() {
		$('span#xval').hide();

		if (this.value == "At Least") {
			$('span#xval').css('display','inline');
		} else if (this.value == "Exactly") {
				$('span#xval').css('display','inline');
		} else if (this.value == "No More Than") {
				$('span#xval').css('display','inline');
		}
	}

$('#walksheet_voting_history_type_filter_attributes_string_val').bind("change", xvalShowHide);

});



