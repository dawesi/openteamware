<cfquery name="q_select_original_messages" datasource="#request.a_str_db_tools#">
SELECT
	uid,
	dt_created,
	foldername,
	datatype,
	source,
	messageid
FROM
	emailmetadata_information
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	datatype = 0
	AND
	messageid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.references#" list="yes">)
;
</cfquery>