<!--- //

	remove all alerts that have not been accessed for the last 7 days
	
	// --->
	
<cfset a_dt_check = DateAdd("d", -14, now())>

<cfquery name="q_delete_old_records" datasource="#request.a_str_db_tools#">
DELETE FROM reminderalerts
WHERE dt_insert < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_check)#">;
</cfquery>