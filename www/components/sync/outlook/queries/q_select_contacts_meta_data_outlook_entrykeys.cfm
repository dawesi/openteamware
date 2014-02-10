<cfquery name="q_select_contacts_meta_data_outlook_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	addressbookkey,
   	outlook_id,
	program_id,
	lastupdate
FROM
	addressbook_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
;
</cfquery>