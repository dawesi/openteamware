
<cfset a_str_program_id = form.program_id>

<cfquery name="q_select_scratchpad_full_data" datasource="#request.a_str_db_scratchpad#">
SELECT
	scratchpad.entrykey,
	scratchpad.subject AS title,
	scratchpad_outlook_id.lastupdate AS dt_lasttimemodified,
	scratchpad.dt_lastmodified AS dt_lasttimemodified_original,
	scratchpad_outlook_id.outlook_id,
	scratchpad.notice
FROM
	scratchpad 
LEFT JOIN
	scratchpad_outlook_id ON
	(scratchpad_outlook_id.scratchpad_entrykey = scratchpad.entrykey) AND ((scratchpad_outlook_id.program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_program_id#">))
WHERE
	(scratchpad.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">)
	AND
	(scratchpad.itemtype = 0)
	AND
	(scratchpad.entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#form.ids#">))
;
</cfquery>