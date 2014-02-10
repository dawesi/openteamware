

<cfquery name="q_select_log_object" datasource="#request.a_str_db_log#">
SELECT
	userkey,
	DATE_ADD(dt_done, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_done
	,failed,actionname 
FROM
	performedactions
WHERE
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	dt_done DESC
;
</cfquery>