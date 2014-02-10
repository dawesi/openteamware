<cfquery datasource="#request.a_str_db_tools#" name="q_select_comments">
SELECT
	entrykey,objectkey,servicekey,comment,dt_created,userkey
FROM
	comments
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
ORDER BY
	dt_created DESC
;
</cfquery>