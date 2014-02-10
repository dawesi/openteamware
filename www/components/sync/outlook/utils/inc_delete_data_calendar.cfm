<!---
	
	Important: Delte only data where the user is owner of the object

	--->
	
<cfquery name="q_select_outlook_ids" datasource="#request.a_str_db_tools#">
SELECT
	eventkey
FROM
	calendar_outlook_data
WHERE
	outlook_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.outlook_ids#" list="yes">)
;
</cfquery>

<cfoutput query="q_select_outlook_ids">
	
	<!--- 
		
		delete now
		
	--->
	
	<cfquery name="q_select_ownerkey" datasource="#request.a_str_db_tools#">
	SELECT
		userkey
	FROM
		calendar
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_outlook_ids.eventkey#">
	;
	</cfquery>
	
	<cfif q_select_ownerkey.recordcount IS 1 AND Compare(q_select_ownerkey.userkey, arguments.securitycontext.myuserkey) IS 0>
	
		<!--- delete now ... --->
		<cfinvoke component="#application.components.cmp_calendar#" method="DeleteEvent" returnvariable="stReturn_delete">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#q_select_outlook_ids.eventkey#">
		</cfinvoke>
		
	</cfif>
	
</cfoutput>