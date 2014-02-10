<!--- //

	Module:		AddressBook
	Function:	DeleteContact
	Description: 
	

// --->

<cfquery name="q_delete_outlook_meta_data" datasource="#GetDSName('DELETE')#">
DELETE FROM
	addressbook_outlook_data
WHERE
	addressbookkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

