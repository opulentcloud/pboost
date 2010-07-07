var polygon_index = -1;
var overlays = new Array();
var colors = ["red","blue","orange","purple","yellow","green"];

function build_vertices(polygon){
	v = '';
	for(var i = 0; i < polygon.getVertexCount(); i++) {
		v += '[' + polygon.getVertex(i).toUrlValue() + '],';
	}
	v = '[' + v.substring(0, v.length - 1) + ']';
	return v;
}

