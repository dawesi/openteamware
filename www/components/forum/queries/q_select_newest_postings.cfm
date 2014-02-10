<!--- //

	Module:		Forum
	Function:	SelectNewestPostings
	Description: 
	

// ---> 
<cfset a_dt_check = CreateODBCDateTime(DateAdd('d', -arguments.maxage_days, Now())) />

<cfquery name="q_select_newest_postings" datasource="#request.a_str_db_tools#">
SELECT
	subject,entrykey,
	DATE_ADD(dt_threadlastmodified, INTERVAL -#val(arguments.usersettings.UTCDIFF)# HOUR) AS dt_threadlastmodified,
	forumkey,lastpostinguserkey
FROM
	postings
WHERE
	forumkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forenkeys#" list="yes">)
	AND
	parentpostingkey = ''
	AND
	dt_threadlastmodified > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_check#">
ORDER BY
	dt_threadlastmodified DESC
LIMIT
	#val(arguments.max_rows)#
;
</cfquery>


