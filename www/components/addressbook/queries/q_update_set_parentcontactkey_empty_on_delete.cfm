<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	

	
	
	Set the parentcontactkey to empty string in case an account is deleted
	otherwise the contacts would not be visible any more in the system
	
	TODO: To test!!
	
// --->

<cfquery name="q_update_set_parentcontactkey_empty_on_delete" datasource="#GetDSName('UPDATE')#">
UPDATE
	addressbook
SET
	parentcontactkey = ''
WHERE
	parentcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

