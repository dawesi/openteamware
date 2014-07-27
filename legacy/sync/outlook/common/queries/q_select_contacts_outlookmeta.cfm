<cfquery name="q_select_contacts_outlookmeta" datasource="#request.a_str_db_tools#">
SELECT
	addressbookkey
FROM
	addressbook_outlook_data
WHERE
	program_id = ''
;
</cfquery>