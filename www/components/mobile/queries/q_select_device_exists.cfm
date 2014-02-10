<cfquery name="q_select_device_exists" datasource="#request.a_str_db_syncml#">
SELECT	
	COUNT(id) AS count_id
FROM
	sync4j_device
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceid#">
;
</cfquery>