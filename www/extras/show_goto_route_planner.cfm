<html>
	<head>
	
	
<!--- //

	show route ...
	
	// --->
	
<cfparam name="url.frmsubmitlocationAonly" type="string" default="">
<cfparam name="url.frmsubmitlocationBonly" type="string" default="">
<cfparam name="url.frmsubmit" type="string" default="">
<cfparam name="url.frmcountry1" type="string" default="">
<cfparam name="url.frmcity1" type="string" default="">
<cfparam name="url.frmstreet1" type="string" default="">
<cfparam name="url.frmzipcode1" type="string" default="">
<cfparam name="url.frmcountry2" type="string" default="">
<cfparam name="url.frmcity2" type="string" default="">
<cfparam name="url.frmstreet2" type="string" default="">
<cfparam name="url.frmzipcode2" type="string" default="">

<cfif len(url.frmsubmit) gt 0>
	<!--- show route from A to B --->
	
	<cfinvoke component="/components/tools/cmp_route_planner" method="getrouteplannerurl" returnvariable="sReturn">
		<cfinvokeargument name="title" value="Standort bestimmen">
		<cfinvokeargument name="actiontype" value="route">
		<cfinvokeargument name="country1" value="#url.frmcountry1#">
		<cfinvokeargument name="street1" value="#url.frmstreet1#">
		<cfinvokeargument name="zipcode1" value="#url.frmzipcode1#">
		<cfinvokeargument name="city1" value="#url.frmcity1#">
		<cfinvokeargument name="country2" value="#url.frmcountry2#">
		<cfinvokeargument name="street2" value="#url.frmstreet2#">
		<cfinvokeargument name="zipcode2" value="#url.frmzipcode2#">
		<cfinvokeargument name="city2" value="#url.frmcity2#">		
	</cfinvoke>
	
	<!--- goto URL --->
	<meta http-equiv="refresh" content="0;URL=<cfoutput>#sReturn#</cfoutput>">
	
<cfelseif len(url.frmsubmitlocationAonly) gt 0>

	<!--- show location of A --->
	
	<cfinvoke component="/components/tools/cmp_route_planner" method="getrouteplannerurl" returnvariable="sReturn">
		<cfinvokeargument name="title" value="Standort bestimmen">
		<cfinvokeargument name="actiontype" value="location">
		<cfinvokeargument name="country1" value="#url.frmcountry1#">
		<cfinvokeargument name="street1" value="#url.frmstreet1#">
		<cfinvokeargument name="zipcode1" value="#url.frmzipcode1#">
		<cfinvokeargument name="city1" value="#url.frmcity1#">
	</cfinvoke>
	
	<!--- goto URL --->
	<meta http-equiv="refresh" content="0;URL=<cfoutput>#sReturn#</cfoutput>">
	
<cfelseif len(url.frmsubmitlocationBonly) gt 0>
	<!--- B ... --->
	<cfinvoke component="/components/tools/cmp_route_planner" method="getrouteplannerurl" returnvariable="sReturn">
		<cfinvokeargument name="title" value="Standort bestimmen">
		<cfinvokeargument name="actiontype" value="location">
		<cfinvokeargument name="country1" value="#url.frmcountry2#">
		<cfinvokeargument name="street1" value="#url.frmstreet2#">
		<cfinvokeargument name="zipcode1" value="#url.frmzipcode2#">
		<cfinvokeargument name="city1" value="#url.frmcity2#">
	</cfinvoke>
	
	<!--- goto URL --->
	<meta http-equiv="refresh" content="0;URL=<cfoutput>#sReturn#</cfoutput>">
</cfif>

<style>
	body,p,td{font-family:Verdana;}
</style>
</head>
<body>
	<br><br><br><br><br>
	<p align="center"><b><cfoutput>#GetLangVal('extras_ph_map_being_loaded')#</cfoutput></b></p>
</body>
</html>