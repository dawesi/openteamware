<!--- //

	load userdata ...
	
	// --->

<cfparam name="LoadUserdataRequest.userid" type="numeric" default="0">
<cfparam name="LoadUserdataRequest.entrykey" type="string" default="">

<cfif Len(LoadUserdataRequest.entrykey) GT 0>
	<cfif StructKeyExists(request, 'queries_q_load_userdata_' & Hash(LoadUserdataRequest.entrykey))>
		
		<cfset q_load_userdata = request['queries_q_load_userdata_' & Hash(LoadUserdataRequest.entrykey)]>
		
		<cfexit method="exittemplate">
	</cfif>
</cfif>

<cfquery name="q_load_userdata" datasource="#request.a_str_db_users#">
SELECT
	<cfif Len(arguments.fieldnames) IS 0>
	*
	<cfelse>
	#arguments.fieldnames#
	</cfif>
FROM
	users
WHERE

<cfif len(LoadUserdataRequest.entrykey) gt 0>
	<!--- entrykey is given ... --->
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadUserdataRequest.entrykey#">
<cfelse>
	<!--- userid is given ... --->
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LoadUserdataRequest.userid#">
</cfif>
;
</cfquery>

<cfif Len(LoadUserdataRequest.entrykey) GT 0>
	<cfset request['queries_q_load_userdata_' & Hash(LoadUserdataRequest.entrykey)] = q_load_userdata>
</cfif>