<!--- //

	handle various asyncon calls in one central place ...
	
	// --->
	
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>
	
<cfparam name="url.servicekey" type="string" default="">

<cfswitch expression="#url.servicekey#">
	
	<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
		<!--- email --->
		<cfinclude template="email/inc_index.cfm">
	</cfcase>
	
	<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
		<!--- calendar --->
		<cfinclude template="calendar/inc_index.cfm">
	</cfcase>
	
	<cfdefaultcase>
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="data" type="html">
		<cfdump var="#form#">
		<cfdump var="#url#">
		</cfmail>
	</cfdefaultcase>

</cfswitch>

