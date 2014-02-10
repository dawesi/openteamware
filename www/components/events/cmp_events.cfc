<cfcomponent>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="LogEvent" output="false" returntype="boolean">
		<cfargument name="servicekey" type="string" required="yes">
		<cfargument name="objectkey" type="string" required="yes">
		<cfargument name="action" type="string" required="yes">
		<cfargument name="sender" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		
		<!--- load all users of this company and check if the've got enabled handlers? --->
		
		
		
		<!--- load event handlers --->
		<cfinclude template="queries/q_select_event_handlers.cfm">
		
		<cfif q_select_event_handlers.recordcount IS 0>
			<cfreturn true>
		</cfif>
		
		<cfoutput query="q_select_event_handlers">
			<!--- insert event ... --->
			<cfinclude template="queries/q_insert_ws_event.cfm">
		</cfoutput>
		
		<cfreturn true>
	</cffunction>

</cfcomponent>