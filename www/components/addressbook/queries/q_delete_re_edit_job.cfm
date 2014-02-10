<cfquery name="q_delete_re_edit_job" datasource="#GetDSName('DELETE')#">
DELETE FROM
	remoteedit
WHERE
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	OR
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>