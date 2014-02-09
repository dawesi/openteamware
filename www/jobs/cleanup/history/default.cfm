<!--- //

	remove title & query_string information from clickstream table in order to save space
	
	// --->
	
<cfset a_dt_check = DateAdd('d', -7, Now())>

<cfquery name="q_update_clickstream" datasource="#request.a_str_db_log#">
UPDATE
	clickstream
SET
	title = '',
	query_string = ''
WHERE
	dt_created < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_check)#">
;
</cfquery>