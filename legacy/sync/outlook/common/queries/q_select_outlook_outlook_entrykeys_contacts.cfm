<cfquery name="q_select_outlook_outlook_entrykeys_contacts" datasource="#request.a_str_db_tools#">
SELECT
	addressbookkey,
   	outlook_id,
	program_id,
	lastupdate
FROM
	addressbook_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.program_id#">
;
</cfquery>