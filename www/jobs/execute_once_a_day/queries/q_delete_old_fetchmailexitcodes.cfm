<!--- //

	Module:		delete old fetchmail exit codes
	Description: 
	

// --->

<cfset a_dt_deletefrom = DateAdd("d", -1, now()) />

<cfquery name="q_delete_old_exitcodes" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	fetchmailexitcodes 
WHERE
	dt_check < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_deletefrom)#">
;
</cfquery>

