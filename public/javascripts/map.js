
var geocoder = new GClientGeocoder();

function showAdress(address) {

	if (geocoder) {
		geocoder.getLatLng(address,
			function(point) {
				if (!point) {
					alert(address + " cound not be found");
				} else {
					clearMap();
					map.setCenter(point, 13);
				}
			});
		}
	}
}

function clearMap() {
	map.clearOverlays();
}
