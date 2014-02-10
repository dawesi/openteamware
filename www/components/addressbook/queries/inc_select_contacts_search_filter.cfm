<!--- //

	Module:		Address Book
	Function:	GetAllContacts
	Description:Apply simly filter, e.g.
				
				Dummy search all over all fields,
				
				
	

// --->

AND
	(addressbook.contacttype IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filterdatatypes#" list="yes">))

<cfif StructKeyExists(arguments.filter, 'search') AND Len(arguments.filter.search) GT 0>
	<cfset a_bol_filtered = true>
	/* Dummy search ... */
	
	AND
	(
		(LOWER(addressbook.surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.firstname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.company) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.department) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)		
		OR
		(LOWER(addressbook.b_city) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)		
		OR
		(LOWER(addressbook.b_country) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.email_prim) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)				
		OR
		(LOWER(addressbook.email_adr) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.b_zipcode) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.p_zipcode) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.b_city) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.p_city) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)
		OR
		(LOWER(addressbook.notice) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.search)#%">)		
	)	
</cfif>


<!--- only select a certain contact type, e.g. accounts or leads ...  --->
<cfif StructKeyExists(arguments.filter, 'contacttype')>
	AND
		(addressbook.contacttype IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.contacttype#" list="yes">))
</cfif>

<!--- ignore archive items ... not supported ny more
<cfif StructKeyExists(arguments.filter, 'NoArchiveItems') AND arguments.filter.NoArchiveItems>
	AND
		(addressbook.archiveentry = 0)
</cfif>
--->

<cfif StructKeyExists(arguments.filter, 'maincontactsonly') AND arguments.filter.maincontactsonly AND NOT a_bol_filtered>
	<!--- main contacts only ... --->
	AND
		(addressbook.parentcontactkey = '')
</cfif>

<!--- only a certain category ... --->
<cfif StructKeyExists(arguments.filter, 'category') AND Len(arguments.filter.category) GT 0>
	<cfset a_bol_filtered = true>
	AND
	(
		(UPPER(addressbook.categories) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(arguments.filter.category)#%">)
	)
</cfif>

<!--- a certain startchar ... --->
<cfif StructKeyExists(arguments.filter, 'startchar') AND Len(arguments.filter.startchar) IS 1>
	<cfset a_bol_filtered = true>
	<!--- startchar ... --->
	AND
	(UPPER(addressbook.surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.filter.startchar)#%">)
</cfif>

