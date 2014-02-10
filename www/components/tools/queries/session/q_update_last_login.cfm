<!--- //

	Module:		Session
	Function:	UpdateLastLoginAndLoginCount
	Description: 
	

// --->
<cfquery name="q_select_login_count" datasource="#request.a_Str_db_users#">
SELECT
	login_count
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

<cfset a_int_new_count = val(q_select_login_count.login_count) + 1 />

<!--- login count updaten --->
<cfquery name="q_update_login" datasource="#request.a_Str_db_users#">
UPDATE
	users
SET
	lasttimelogin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	login_count = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_count#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>


