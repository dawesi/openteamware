<cfcomponent output=false>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="remote" name="AllowedAuthentificationModes" output="false" returntype="string" hint="return a list of allowed authentification methods for a specified username">
		<cfargument name="username" type="string" required="yes" hint="the username">
		
		<cfreturn 'clientkey,directmode'>
	</cffunction>
		
	<!--- return the key for requesting a clientkey --->
	<cffunction access="remote" name="RequestClientKey" output="false" returntype="array">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="success_url" type="string" required="no" default="">
		<cfargument name="error_url" type="string" required="no" default="">
		
		<cfset var a_arr_return = GenerateReturnArray()>
				
		<!--- user exists? --->
		<cfset a_str_userkey = application.components.cmp_user.GetEntrykeyFromUsername(username = arguments.username)>
		
		<cfif Len(a_str_userkey) IS 0>
			<cfset a_arr_return[1] = 201>
			<cfset a_arr_return[2] = 'user does not exist'>
			
			<cfif Len(arguments.error_url) GT 0>
				
			</cfif>
			
			<cfreturn a_arr_return>
		</cfif>
		
		<!--- check if application is allowed --->
		
		<!--- already set? --->
		<!---<cfinclude template="queries/q_select_clientkey_already_issued.cfm">
		
		<cfif q_select_clientkey_already_issued.count_id IS 1>
			<cfset a_arr_return[1] = 202>
			<cfset a_arr_return[2] = 'clientkey has already been issued. Please delete the established binding.'>
			
			<cfif Len(arguments.error_url) GT 0>
			
			</cfif>
			
			<cfreturn a_arr_return>
		</cfif>--->
		
		<!--- check if request has already been started ... re-request --->
		<cfinclude template="queries/q_delete_old_requests.cfm">
		
		<cfif Len(arguments.username) IS 0>
			<cfset a_arr_return[1] = 201>
			<cfset a_arr_return[2] = 'invalid username'>
			
			<cfif Len(arguments.error_url) GT 0>
			
			</cfif>
			
			<cfreturn a_arr_return>
		</cfif>
		
		<cfset a_str_request_key = createuuid()>
		
		<!--- insert request ... --->
		<cfinclude template="queries/q_insert_request.cfm">
		
		<!--- return the request key --->
		<cfset a_arr_return[3] = a_str_request_key>
		<!--- return the confirmation url --->
		<cfset a_arr_return[4] = 'https://www.openTeamWare.com/directaccess/?applicationkey='&urlencodedformat(arguments.applicationkey)&'&username='&urlencodedformat(arguments.username)&'&requestkey='&urlencodedformat(a_str_request_key)>
		
		<cfif Len(arguments.success_url) GT 0>
			<!--- call the success url ... --->
		</cfif>
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetClientKey" output="false" returntype="array">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="requestkey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<!--- check if the clientkey is "ready" --->
		<cfinclude template="queries/q_select_clientkey_ready.cfm">
		
		<cfif q_select_clientkey_ready.recordcount IS 1>
			<!--- ok, go! --->
			<cfset a_arr_return[3] = q_select_clientkey_ready.clientkey>
		<cfelse>
			<!--- return empty string --->
			<cfset a_arr_return[1] = 202>
			<cfset a_arr_return[2] = 'Clientkey has already been delivered'>
			<cfreturn a_arr_return>
			
		</cfif>
		
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetProperties" output="false" returntype="array">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="clientkey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>

		<!--- allow edit --->
		<cfset stReturn[3] = true>
		<!--- allow delete --->
		<cfset stReturn[4] = true>
		
		<cfreturn a_arr_return>	
	</cffunction>
	
	
</cfcomponent>