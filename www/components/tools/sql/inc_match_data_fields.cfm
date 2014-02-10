<!--- //

	Component:	SQL
	Function:	MatchDataAndFields
	Description:Check which fields have been provided and fill them
	

	
	
	fields to add if not been provided in data and field exists
	
	userkey ... securitycontext.myuserkey
	createdbyuserkey ... same (CREATE only)
	lasteditedbyuserkey ... same
	dt_created ... now (CREATE only)
	dt_lastmodified ... now
	
// --->

<!--- set fix values ... first ones for INSERT only, others for all ... --->
<cfif arguments.action IS 'INSERT'>
	
	<!--- who has created this record? --->
	<cfif ListFindNoCase(arguments.fieldlist, 'createdbyuserkey') GT 0>
		<cfset arguments.data.createdbyuserkey = arguments.securitycontext.myuserkey />
	</cfif>
	
	<!--- owner ... --->
	<cfif (ListFindNoCase(arguments.fieldlist, 'userkey') GT 0) AND NOT
		StructKeyExists(arguments.data, 'userkey')>
		<cfset arguments.data.userkey = arguments.securitycontext.myuserkey />
	</cfif>
	
	<!--- entrykey ... does the field exist and has the key been provided? --->
	<cfif (ListFindNoCase(arguments.fieldlist, 'entrykey') GT 0)>
	
		<!--- return the given entrykey or a new one? ... --->
		<cfif StructKeyExists(arguments.data, 'entrykey') AND (Len(arguments.data.entrykey) GT 0)>
			<cfset sEntrykey = arguments.data.entrykey />
		<cfelse>
			<cfset sEntrykey = CreateUUID() />
			<cfset arguments.data.entrykey = CreateUUID() />
		</cfif>
	
	</cfif>
	
	<cfif ListFindNoCase(arguments.fieldlist, 'dt_created') GT 0>
		<cfset arguments.data.dt_created = GetODBCUTCNow() />
	</cfif>
	
</cfif>

<cfif ListFindNoCase(arguments.fieldlist, 'lastmodifiedbyuserkey') GT 0>
	<cfset arguments.data.lastmodifiedbyuserkey = arguments.securitycontext.myuserkey />
</cfif>
	
<cfif ListFindNoCase(arguments.fieldlist, 'dt_lastmodified') GT 0>
	<cfset arguments.data.dt_lastmodified = GetODBCUTCNow() />
</cfif>

<!--- loop through all provided data fields and set the data to the corresponding field ... --->
<cfset a_str_data_fields = StructKeyList(arguments.data) />

<!--- ok, loop now through fields ... --->
<cfloop from="1" to="#ArrayLen(arguments.fields)#" index="ii">

	<cfif ListFindNoCase(a_str_data_fields, arguments.fields[ii].fieldname) GT 0>
		
		<!--- data (value entered by user) and provided (is field valid and should be inserted) ... --->
		<cfset a_str_data = arguments.data[arguments.fields[ii].fieldname] />
		<cfset a_bol_provided = true />
	
		<!--- set data ... plus provided to true ... --->
		<cfif ListFindNoCase('cf_sql_timestamp,cf_sql_date', arguments.fields[ii].cfmxtype) GT 0>

			<cfif IsDate(a_str_data)>
				<cfif FindNoCase('{ts', a_str_data) IS 0>
					<cfset a_str_data = CreateODBCDateTime(LSParseDateTime(a_str_data)) />
				</cfif>
			<cfelse>
				<!--- no date, do not insert ... --->
				<cfset a_bol_provided = false />
			</cfif>

		</cfif>
		
		<!--- make sure full number ... --->
		<cfif arguments.fields[ii].cfmxtype IS 'cf_sql_integer'>
			<cfset a_str_data = Val(a_str_data) />
		</cfif>
		
		<cfset arguments.fields[ii].data = a_str_data />
		<cfset arguments.fields[ii].provided = a_bol_provided />
	
	</cfif>

</cfloop>

<!--- now remove all fields which not have been provided ... --->
<cfloop from="1" to="#ArrayLen(arguments.fields)#" index="ii">

	<cfif arguments.fields[ii].provided>
		<cfset a_arr_real_data[ArrayLen(a_arr_real_data) + 1] = Duplicate(arguments.fields[ii]) />
	</cfif>

</cfloop>

