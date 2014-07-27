<!---

	--->
	
<cfquery name="q_select_foren_postings" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,forumkey,userkey,subject,parentpostingkey,postingbody,
	DATE_ADD(dt_created, INTERVAL -#val(arguments.usersettings.utcdiffonly)# HOUR) AS dt_created,
	DATE_ADD(dt_threadlastmodified, INTERVAL -#val(arguments.usersettings.utcdiffonly)# HOUR) AS dt_threadlastmodified,
	priority,
	subpostingscount,mood,lastpostinguserkey
FROM
	postings
WHERE
	forumkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	dt_threadlastmodified DESC
;
</cfquery>
