<!--- //

	Module:		Address Book
	Action:		DoShowGoogleMaps
	Description:Show google maps information
	

// --->

<cfparam name="url.markertext" type="string" default="">
<cfparam name="url.lon" type="string" default="">
<cfparam name="url.lat" type="string" default="">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Google Maps</title>
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=<cfoutput>#application.a_struct_appsettings.properties.GoogleMapsAPIKey#</cfoutput>" type="text/javascript"></script>
	
	<cfsavecontent variable="a_str_js">
		var WINDOW_HTML = '<div style="font-size:11px;"><cfoutput>#jsstringformat(url.markertext)#</cfoutput></div>';
		
    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
       	map.addControl(new GSmallMapControl());
		map.addControl(new GMapTypeControl());
        // lat / lon
        <cfoutput>
        map.setCenter(new GLatLng(#url.lon#, #url.lat#), 15);
		var marker = new GMarker(new GLatLng(#url.lon#, #url.lat#));
		</cfoutput>
      	map.addOverlay(marker);
     
      	marker.openInfoWindowHtml(WINDOW_HTML);
      	}
    	}
    </cfsavecontent>
	
	<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
  </head>
  <body onload="load()" onunload="GUnload()" style="padding:0px;">
    <div id="map" style="width: 740px; height: 380px"></div>
  </body>
</html>


