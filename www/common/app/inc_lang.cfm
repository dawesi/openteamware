<!--- //

	language properties ...
	
	// --->
	

<!--- language --->
<cfparam type="numeric" name="client.langno" default="0">

<!--- die lokale Zone setzen --->
<cfswitch expression="#client.langno#">
	<cfcase value="0">
	<!--- AT/DE --->
	<cfset SetLocale ("German (Austrian)")>
	</cfcase>
	
	<cfcase value="1">
	<!--- US --->
	<cfset SetLocale("English (US)")>
	</cfcase>
	
	<cfdefaultcase>
	<!--- standard schema: english --->
	</cfdefaultcase>

</cfswitch>