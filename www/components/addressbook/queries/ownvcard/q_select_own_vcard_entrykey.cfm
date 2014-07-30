<!--- //

	Module:		Address Book
	Function:	GetOwnContactCardEntrykey
	Description:Return the entrykey of the own address book item 
	
// --->

<cfquery name="q_select_own_vcard_entrykey">
SELECT
	contactkey
FROM
	owncontactcards
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>
