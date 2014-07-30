<!--- //

	Module:		Address Book
	Function:	GetAllContacts
	Description:Check if cached list of contacts is available
	

// --->

<cfquery name="q_select_cached_ids_available">
SELECT
	ids,
	data1,
	data2,
	items_count
FROM
	cached_ids
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sServiceKey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	parameters = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(a_str_param_string)#">
;
</cfquery>

