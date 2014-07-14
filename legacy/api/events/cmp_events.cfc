<cfcomponent>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	
	<cffunction access="remote" name="CheckEvents" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="filter" type="string" required="no" default="">
		<cfargument name="handlerkey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfinclude template="queries/q_select_events.cfm">
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="RegisterEventHandler" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<!--- 0 ... post to a url, 1 = call webservice
		
			the webservice has always to have the same name ...
			
			InBoxccEventHandler
			
				arguments:
				
				servicekey
				entrykey
				actionname
							
			--->
		<cfargument name="handlertype" type="numeric" default="0" required="yes">
		<cfargument name="href" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfset var sEntrykey = CreateUUID()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<!--- already exists? --->
		
		<!--- return the entrykey of the handler --->
		<cfinclude template="queries/q_insert_handler.cfm">
		
		<cfset a_arr_return[3] = sEntrykey>
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="RemoveEventHandler" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfreturn a_arr_return>
	
	</cffunction>
	
	<cffunction access="remote" name="GetEventHandlerStatus" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<!--- return the data in xml format --->
		
		
		<cfreturn a_arr_return>
	</cffunction>
	
</cfcomponent>