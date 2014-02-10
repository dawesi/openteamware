<!--- //

	Module:		Address Book
	Description:Select the raw contact by it's entrykey
	

// --->

<cfquery name="q_select_contact_raw" datasource="#GetDSName()#">
SELECT
	*
FROM
	addressbook
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

