<cfinclude template="/login/check_logged_in.cfm">

<cfquery name="q_update_name" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmfirstname#">,
	surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmsurname#">,
	sex = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmsex)#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">