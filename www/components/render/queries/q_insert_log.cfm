<!--- //

	Module:		render
	Function:	GenerateServiceDefaultFile
	Description: 
	

// --->

<cfif NOT StructKeyExists(request, 'sCurrentServiceKey')>
	<cfexit method="exittemplate">
</cfif>

<cfif StructKeyExists(request, 'stSecurityContext')>
	<cfset variables.a_str_userkey_log = request.stSecurityContext.myuserkey />
<cfelse>
	<cfset variables.a_str_userkey_log = '' />
</cfif>

<cfif StructKeyExists(url, 'action')>
	<cfset variables.a_str_url_action_name = url.action />
<cfelse>
	<cfset variables.a_str_url_action_name = '' />
</cfif>

<cfif StructKeyExists(request, 'a_str_current_page_title')>
	<cfset variables.a_str_current_page_title = Mid(request.a_str_current_page_title, 1, 100) />
<cfelse>
	<cfset variables.a_str_current_page_title = '' />
</cfif>

<cfquery name="q_insert_log_clickstream">
INSERT DELAYED INTO
	clickstream
	(
	userkey,
	dt_created,
	servicekey,
	action,
	runtime,
	title,
	query_string
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.a_str_userkey_log#">,
	CURRENT_TIMESTAMP,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.sCurrentServiceKey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(variables.a_str_url_action_name, 1, 50)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(variables.a_tc_count_runtime_fw)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(variables.a_str_current_page_title, 1, 70)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left( cgi.QUERY_STRING, 255)#">
	)
;
</cfquery>