<cfcomponent>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	
	<cffunction access="remote" name="GetEvent" returntype="string" output="false"
			hint="return a certain event by it's entrykey">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">		
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetEvents" returntype="array" output="false"
			hint="return the events between two dates">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="date_start" type="date" required="yes">
		<cfargument name="date_end" type="date" required="yes">
		<cfargument name="calculate_repeating_events" type="boolean" required="false" default="false"
			hint="calculate all repeating events">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfif arguments.date_end LTE arguments.date_start>
			<cfset arguments.date_end = DateAdd('d', 1, arguments.date_start)>
		</cfif>
		
		<cfset request.stUserSettings = application.directaccess.usersettings[arguments.clientkey]>
		
		<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
			<cfinvokeargument name="startdate" value="#arguments.date_start#">
			<cfinvokeargument name="enddate" value="#arguments.date_end#">
			<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
			<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">
		</cfinvoke>		
		
		<cfset q_select_events = stReturn.q_select_events>
		
		<cfset a_arr_return[3] = ToString(QueryToXMLData(q_select_events))>	
				
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="CreateEvent" returntype="string" output="false"
			hint="create a new event">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="xmldata" type="string" required="yes">
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
				
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="UpdateEvent" returntype="string" output="false"
			hint="update an event (referenced by entrykey)">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="xmldata" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">		
		
		<cfreturn a_arr_return>
	</cffunction>

</cfcomponent>