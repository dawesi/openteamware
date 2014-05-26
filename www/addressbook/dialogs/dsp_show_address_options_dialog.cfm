<!--- //

	Module:		Address Book
	Action:		OpenAddressOptionsDialog
	Description:Display route planing ...
	

// --->

<cfprocessingdirective pageencoding="UTF-8">

<cfparam name="url.contactkey" type="string" default="">
<cfparam name="url.adt_type" type="string" default="business">
<cfparam name="url.street" type="string" default="">
<cfparam name="url.country" type="string" default="">
<cfparam name="url.zipcode" type="string" default="">
<cfparam name="url.city" type="string" default="">

<!--- only return house number, no further details ... --->
<cfif FindNoCase('/', url.street) GT 0>
	<cfset url.street = ListGetAt(url.street, 1, '/') />
</cfif>

<!--- load data of user ... --->
<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfset variables.a_cmp_route_planner = CreateObject('component', '/components/tools/cmp_route_planner') />

<cfinvoke component="#variables.a_cmp_route_planner#" method="getrouteplannerurl" returnvariable="sReturn_routeplanner">
	<cfinvokeargument name="title" value="Standort bestimmen">
	<cfinvokeargument name="actiontype" value="location">
	<cfinvokeargument name="country1" value="#url.country#">
	<cfinvokeargument name="street1" value="#url.street#">
	<cfinvokeargument name="zipcode1" value="#url.zipcode#">
	<cfinvokeargument name="city1" value="#url.city#">
</cfinvoke>

<cfinvoke component="#variables.a_cmp_route_planner#" method="getrouteplannerurl" returnvariable="sReturn_routeplanner_route">
	<cfinvokeargument name="title" value="Standort bestimmen">
	<cfinvokeargument name="actiontype" value="route">
	<cfinvokeargument name="country1" value="#q_select_user_data.country#">
	<cfinvokeargument name="street1" value="#q_select_user_data.address1#">
	<cfinvokeargument name="zipcode1" value="#q_select_user_data.zipcode#">
	<cfinvokeargument name="city1" value="#q_select_user_data.city#">
	<cfinvokeargument name="country2" value="#url.country#">
	<cfinvokeargument name="street2" value="#url.street#">
	<cfinvokeargument name="zipcode2" value="#url.zipcode#">
	<cfinvokeargument name="city2" value="#url.city#">
</cfinvoke>	

<cfswitch expression="#url.country#">
	<cfcase value="at,Österreich">
			<cfset url.country = 'Austria' />
	</cfcase>
	<cfcase value="de,Deutschland">
		<cfset url.country = 'Germany' />
	</cfcase>
</cfswitch>

<cfset a_str_address = url.street & ',' & url.zipcode & ' ' & url.city & ',' & url.country />

<cflock name="lck_get_google_maps_pos" type="exclusive" timeout="30">
<cfhttp url="http://maps.google.com/maps/geo?q=#a_str_address#&output=xml&key=#application.a_struct_appsettings.properties.GoogleMapsAPIKey#">
</cfhttp>

<cfset a_xml_obj = xmlparse(cfhttp.FileContent) />

</cflock>

<!--- check if an error has occured ... --->
<cftry>
<cfset a_str_responsecode = a_xml_obj['kml']['Response']['Status']['Code'].xmltext />
<cfcatch type="any">
	<cfset a_str_responsecode = 404 />
</cfcatch>
</cftry>

<!--- start new tab nav ... --->
<cfset tmp = StartNewTabNavigation() />

<cfif a_str_responsecode IS 200>
	<cfset a_str_coordinates = a_xml_obj['kml']['Response']['Placemark']['Point']['Coordinates'].xmltext />
	
	<cfset a_str_lat = ListGetAt(a_str_coordinates, 1) />
	<cfset a_str_lon = ListGetAt(a_str_coordinates, 2) />
	<cfset a_str_markertext = a_str_address />
	
	<cfset a_str_id_googlemaps = AddTabNavigationItem('Google Maps', '', '') />
</cfif>


<cfset a_str_id_map24 = AddTabNavigationItem('Map24', '', '') /> 

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>
<!--- 
<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) /> --->

<div id="id_div_areas">
<cfoutput>

<cfif a_str_responsecode IS 200>
<div id="#a_str_id_googlemaps#" class="bt">
<iframe frameborder="0" border="0" name="id_iframe_show_googlemaps" id="id_iframe_show_googlemaps" src="index.cfm?action=DoShowGoogleMaps&markertext=#jsstringformat(a_str_markertext)#&lat=#a_str_lat#&lon=#a_str_lon#" height="420" width="750"></iframe>
</div>
</cfif>

<div id="#a_str_id_map24#" style="display:none;padding:20px;" class="bt">
	<a  href="#sReturn_routeplanner_route#" target="_blank">#GetLangVal('adrb_ph_routeplanner_route')#</a>
	<br />
	<a href="#sReturn_routeplanner#" target="_blank">#GetLangVal('adrb_ph_routeplanner_position')#</a> 
</div>
</cfoutput>
</div>

