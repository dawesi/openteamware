
<cfquery name="q_select_task">
SELECT
	title,status,percentdone,notice,
	priority,mileage,totalwork,actualwork,
	categories,billinginformation,assignedtouserkeys,private,
	
	<!--- add the utc difference of the local user ... --->
	DATE_ADD(dt_lastmodified, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_lastmodified,
	DATE_ADD(dt_due, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_due,
	DATE_ADD(dt_done, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_done,
	DATE_ADD(dt_created, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_created,		
	
	percentdone,userkey,entrykey,lasteditedbyuserkey
FROM
	tasks
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
;
</cfquery>