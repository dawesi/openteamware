<!--- //

	Module:		Locks
	Function:	UpdateServiceInformation
	Description: 
	

// --->

<cfswitch expression="#arguments.servicekey#">
	<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
	
		<cfset a_struct_sql.locked = ReturnZeroOneOnTrueFalse(arguments.lock_exists) />
		<cfset a_struct_sql.entrykey = arguments.objectkey />
		
		<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="database" value="#request.a_str_db_tools#">
			<cfinvokeargument name="table" value="storagefiles">
			<cfinvokeargument name="primary_field" value="entrykey">
			<cfinvokeargument name="data" value="#a_struct_sql#">
			<cfinvokeargument name="action" value="UPDATE">
		</cfinvoke>
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="stReturn_db" type="html">
		<cfdump var="#stReturn_db#">
		<cfdump var="#a_struct_sql#">
		<cfdump var="#arguments#">
		</cfmail>
	
	</cfcase>
</cfswitch>

