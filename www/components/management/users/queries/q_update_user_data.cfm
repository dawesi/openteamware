<!--- //

	Component:	User
	Function:	UpdateUserData
	Description:Update user data ...
	

// --->

<cfquery name="q_update_user_data" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	tmp = 1
	
	<!--- custom style ... --->
	<cfif StructKeyExists(arguments.newvalues, 'style')>
		,style = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.style#">
	</cfif>
	
	<!--- TODO: ADD ALL OTHER POSSIBLE FIELDS ... --->
	
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
;
</cfquery>


