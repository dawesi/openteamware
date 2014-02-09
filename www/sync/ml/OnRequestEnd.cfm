<cfset a_str_response = getPageContext().getCFOutput().getString()>

<cfset a_str_headers = ''>
<cfloop list="#StructKeyList(request.a_struct_response_headers)#" delimiters="," index="a_str_item">
	<cfset a_str_headers = a_str_headers & chr(13) & chr(10) & a_str_item & '=' & request.a_struct_response_headers[a_str_item]>
</cfloop>

<cfset a_str_headers = trim(a_str_headers)>

<cfquery name="q_update_log" datasource="#request.a_str_db_log#">
UPDATE
	syncml_log
SET
	runtime = <cfqueryparam cfsqltype="cf_sql_integer" value="#(GetTickCount() - request.a_str_tc_begin)#">,
	response_body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#trim(a_str_response)#">,
	response_headers = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#trim(a_str_headers)#">
	<cfif IsDefined('request.a_struct_action.a_str_username')>
		,username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_username#">
	</cfif>
	<cfif IsDefined('request.a_struct_action.a_str_virtual_username')>
		,virtualusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_virtual_username#">
	</cfif>
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_log_entrykey#">
;
</cfquery>