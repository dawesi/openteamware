

<cfquery name="q_select_reminders">
SELECT
	entrykey,dt_remind,status,type,remind_email_adr,
	DATE_ADD(dt_remind, INTERVAL -#val(arguments.usersettings.utcdiff)# HOUR) AS dt_remind_local
FROM
	cal_remind
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
;
</cfquery>