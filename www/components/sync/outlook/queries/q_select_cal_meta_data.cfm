
<!--- make a quick dummy query ... load all workgroup items --->

<cfif q_select_workgroup_permissions.recordcount GT 0>
<cfquery name="q_select_workgroup_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	eventkey
FROM
	calendar_shareddata
WHERE
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(q_select_workgroup_permissions.workgroup_key)#">)	
;
</cfquery>

<cfelse>
	<cfset q_select_workgroup_entrykeys = QueryNew('tmp')>
</cfif>

<!--- load events --->
<cfquery name="q_select_cal_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	calendar.entrykey,
	calendar.title,
	calendar.userkey,
	CONCAT(calendar.title, DATE_FORMAT(calendar.date_start, '%d%m%Y%H%i')) AS hashvalue,
	calendar.dt_lastmodified AS dt_lasttimemodified_original,
	calendar_outlook_data.lastupdate AS dt_lasttimemodified,
	calendar_outlook_data.outlook_id
FROM
	calendar
LEFT JOIN
	 calendar_outlook_data ON
	 	(calendar_outlook_data.eventkey = calendar.entrykey) AND ((calendar_outlook_data.program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">))
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	
	<cfif q_select_workgroup_entrykeys.recordcount GT 0>
	OR
	(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_workgroup_entrykeys.eventkey)#" list="yes">))
	</cfif>
;
</cfquery>