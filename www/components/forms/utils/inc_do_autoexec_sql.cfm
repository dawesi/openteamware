<!--- //

	Component:	Forms
	Function:	DoAutoPickupData
	Description:Automatically do db operation 
	

// --->

<cfif stReturn.q_select_request_properties.action_type IS 'create'>
	<cfset a_str_sql_action = 'INSERT' />
<cfelse>
	<cfset a_str_sql_action = 'UPDATE' />
</cfif>

<!--- // create/update // --->
<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_autoexec_sql">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="database" value="#stReturn.q_select_form_properties.db_datasource#">
	<cfinvokeargument name="table" value="#stReturn.q_select_form_properties.db_table#">
	<cfinvokeargument name="primary_field" value="#stReturn.q_select_form_properties.db_primary#">
	<cfinvokeargument name="data" value="#stReturn.a_struct_database_fields#">
	<cfinvokeargument name="action" value="#a_str_sql_action#">
</cfinvoke>

<cfset stReturn.stReturn_autoexec_sql = stReturn_autoexec_sql />

