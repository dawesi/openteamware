<!---

	save the custom header in the database ...
	
	--->
	
<cfquery name="q_update_custom_header" datasource="#request.a_str_db_users#">
UPDATE users
SET customheader = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdata#">
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>

<cflocation addtoken="no" url="default.cfm?action=editcustomheader">