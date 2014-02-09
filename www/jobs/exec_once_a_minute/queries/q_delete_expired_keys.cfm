<!--- //

	Module:		Exec once a minute
	Description: 
	

// --->

<cfquery name="q_delete_expired_keys" datasource="#request.a_str_db_users#">
DELETE FROM
	sessionkeys
WHERE
	dt_expires < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
;
</cfquery>

