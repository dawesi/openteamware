<!---

	--->
	
<cfquery name="q_select_whole_postings" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,forumkey,userkey,subject,parentpostingkey,postingbody,priority,
	DATE_ADD(dt_created, INTERVAL -#val(arguments.usersettings.UTCDIFF)# HOUR) AS dt_created,
	DATE_ADD(dt_threadlastmodified, INTERVAL -#val(arguments.usersettings.UTCDIFF)# HOUR) AS dt_threadlastmodified,
	subpostingscount,mood,lastpostinguserkey,dt_last_updated_by_user 
FROM
	postings
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	OR
	parentpostingkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	dt_created
;
</cfquery>