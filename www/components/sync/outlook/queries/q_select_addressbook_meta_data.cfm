
<!--- make a quick dummy query ... load all workgroup items --->

<cfif q_select_workgroup_permissions.recordcount GT 0>
<cfquery name="q_select_workgroup_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	addressbookkey
FROM
	 shareddata
WHERE
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(q_select_workgroup_permissions.workgroup_key)#">)	
;
</cfquery>
<cfelse>
	<cfset q_select_workgroup_entrykeys = QueryNew('tmp')>
</cfif>

<!--- load events --->
<cfquery name="q_select_addressbook_meta_data" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,
	CONCAT(surname, ', ', firstname) AS title,
	CONCAT(surname, ', ', firstname) AS hashvalue,
	dt_lastmodified AS dt_lasttimemodified_original,
	addressbook_outlook_data.lastupdate AS dt_lasttimemodified,
	addressbook_outlook_data.outlook_id
FROM
	addressbook
LEFT JOIN
	 addressbook_outlook_data ON
	 	(addressbook_outlook_data.addressbookkey = addressbook.entrykey) AND ((addressbook_outlook_data.program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">))
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	
	<cfif q_select_workgroup_entrykeys.recordcount GT 0>
	OR
	(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_workgroup_entrykeys.addressbookkey)#" list="yes">))
	</cfif>
;
</cfquery>