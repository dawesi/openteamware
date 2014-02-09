
<cfquery name="q_select_workgroup_members" datasource="#request.a_str_db_users#">
SELECT
	userkey
FROM
	workgroup_members
;
</cfquery>

<cfoutput query="q_select_workgroup_members">

<cfquery name="q_select_user_exists" datasource="#request.a_str_db_users#">
SELECT
	username,entrykey
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_workgroup_members.userkey#">
;
</cfquery>

<cfif q_select_user_exists.recordcount IS 0>
	<h4>does not exist #q_select_user_exists.username#</h4>
	
	<cfquery name="q_delete" datasource="#request.a_str_db_users#">
	DELETE FROM
		workgroup_members
	WHERE
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_workgroup_members.userkey#">
	;
	</cfquery>
	
</cfif>
</cfoutput>