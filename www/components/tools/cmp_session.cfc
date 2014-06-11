<!--- //

	Module:		Session component
	Description: 
	

	
	
	TODO hp: check Session functions for Update with newer version!
	
// --->

	
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<!--- update the timeout ... --->
	<cffunction access="public" name="UpdateSessionKeyTimeOut" output="false" returntype="boolean">
		<cfargument name="sessionkey" type="string" required="true"
			hint="session key">
		<cfargument name="applicationname" type="string" required="true"
			hint="application name">
		<cfargument name="ip" type="string" required="true">
		
		<!--- load timeout of this user ... --->
		<cfset var a_int_timeout = 30 />
		<cfset var a_dt_timeout = DateAdd("n", a_int_timeout, now()) />
		
		<cfset Variables.a_dt_timeout = DateAdd("n", a_int_timeout, now()) />

		<!--- update now ... --->	
		<cfinclude template="queries/session/q_update_session_key.cfm">		
			
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="CreateSessionEntry" output="false" returntype="struct"
			hint="create a new session item with all the stuff around">
		<cfargument name="sessionkey" type="string" required="false" default=""
			hint="entrykey of session">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of user">
		<cfargument name="applicationname" type="string" required="true"
			hint="name of application">
		<cfargument name="ip" type="string" required="true"
			hint="IP address of request">
		<cfargument name="deleteoldsession" type="boolean" required="false" default="true"
			hint="delete old session?">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="defaulttimeoutinminutes" type="numeric" default="30" required="false"
			hint="default timeout ... in minutes">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_int_timeout = arguments.defaulttimeoutinminutes />
		<cfset var a_bol_tmp_delete = false />
		<cfset var a_dt_timeout = 0 />
		<cfset var q_select_session_exists = 0 />
		<cfset var a_bol_set_data = false />
		
		<!--- if no valid sessionkey has been provided, build a new one ... --->
		<cfif Len(arguments.sessionkey) IS 0>
			<cfset arguments.sessionkey = CreateUUID() />
		</cfif>
		
		<!--- return the sessionkey ... --->
		<cfset stReturn.sessionkey = arguments.sessionkey />
		
		<!--- check if another session already exists ... --->
		<cfinclude template="queries/session/q_select_session_exists.cfm">
				
		<cfif q_select_session_exists.count_id NEQ 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 300) />
		</cfif>
		
		<cfif arguments.deleteoldsession>
			<!--- delete the old session --->
			<cfset a_bol_tmp_delete = DeleteSessionKey(sessionkey = arguments.sessionkey, applicationname = arguments.applicationname) />
		</cfif>
		
		<cfset a_dt_timeout = DateAdd("n", a_int_timeout, now()) />
		
		<!--- insert now new session items ... --->
		<cfinclude template="queries/session/q_insert_session_data.cfm">
		
		<!--- store data ... --->
		<cfset a_bol_set_data = SetSessionStructData(securitycontext=arguments.securitycontext,
									usersettings=arguments.usersettings,
									sessionkey=arguments.sessionkey) />
		
		<!--- set cookie ... and store session key in sesion scope --->
		<cfcookie name="ib_session_key" value="#arguments.sessionkey#">
		
		<cflock name="lck_set_session_key" type="exclusive" timeout="30">
			<cfset session.a_str_sessionkey = arguments.sessionkey />
		</cflock>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="GetUserkeyFromSessionkey" output="false" returntype="string"
			hint="return the userkey of a session key">
		<cfargument name="sessionkey" type="string" required="true">
		
		<cfset var q_select_userkey_from_sessionkey = 0 />

		<cfinclude template="queries/session/q_select_userkey_from_sessionkey.cfm">

		<cfreturn q_select_userkey_from_sessionkey.userkey />
	</cffunction>
	
	<cffunction access="public" name="IsSessionOpen" output="false" returntype="boolean"
			hint="check if a session is still valid">
		<cfargument name="sessionkey" type="string" required="true">
		<cfargument name="applicationname" type="string" required="true">
		<cfargument name="ip" type="string" required="true">
		
		<cfset var q_select_session_exists = 0 />
		
		<cfinclude template="queries/session/q_select_session_exists.cfm">
		
		<cfreturn (val(q_select_session_exists.count_id) IS 1) />
	</cffunction>
	
	<!--- delete a session --->
	<cffunction access="public" name="DeleteSessionKey" output="false" returntype="boolean">
		<cfargument name="sessionkey" type="string" required="true">
		<cfargument name="applicationname" type="string" required="true">
		
		<cfinclude template="queries/session/q_delete_session_key.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetSessionStructData" output="false" returntype="struct"
			hint="convert securitycontext / usersettings of a certain session back to default cfml structure">
		<cfargument name="sessionkey" type="string" required="true">
		
		<cfset var stReturn = StructNew() />
		
		<!--- load data ... --->
		<cfinclude template="queries/session/q_select_session_data.cfm">
		
		<cfif q_select_session_data.recordcount IS 1>
			<!--- data exists --->
			
			<cftry>
			<cfwddx action="wddx2cfml" input="#q_select_session_data.struct_securitycontext#" output="stSecurityContext">
			<cfset stReturn.stSecurityContext = stSecurityContext />
			
			<cfwddx action="wddx2cfml" input="#q_select_session_data.struct_usersettings#" output="stUserSettings">
			<cfset stReturn.stUserSettings = stUserSettings />
			
			<cfcatch type="any">
				<!--- something went wrong --->
			</cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="SetSessionStructData" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="sessionkey" type="string" required="true">
		
		<cfwddx action="cfml2wddx" input="#arguments.securitycontext#" output="a_str_securitycontext">
		<cfwddx action="cfml2wddx" input="#arguments.usersettings#" output="a_str_usersettings">
		
		<!--- update data ... --->
		<cfinclude template="queries/session/q_update_session_data.cfm">

		<cfreturn true />
	</cffunction>

	<cffunction access="public" name="CheckAndUpdateSessionData" output="false" returntype="boolean"
			hint="check everything and return true if session exists (now) or false if no session exists">
		<cfargument name="applicationname" type="string" required="yes">
		<cfargument name="ip" type="string" required="yes">
		<cfargument name="request_scope" type="struct" required="yes">
		<cfargument name="cookies_scope" type="struct" required="yes">
		<!--- if a distinct key is used ... optional!! --->
		<cfargument name="session_key" type="string" required="no" default="">
		<cfargument name="setclientcookies" type="boolean" default="true" required="no">
		
		<cfset var a_bol_result = false />
		<cfset var a_str_sessionkey = '' />
		<cfset var a_bol_session_is_open = false />
		<cfset var a_str_userkey = '' />
		<cfset var tmp = false />
		<cfset var a_struct_session_data = 0 />
		<cfset var a_bol_update = false />
		<cfset var a_str_item = '' />
		
		<!--- search for the session key ... --->
		<cfif Len(arguments.session_key) GT 0>
			<cfset a_str_sessionkey = arguments.session_key />
			
		<cfelseif StructKeyExists(cookie, 'ib_session_key') AND Len(cookie.ib_session_key) GT 0>
			<!--- use the cookie value ... --->
			<cfset a_str_sessionkey = cookie.ib_session_key />
			
		<cfelse>
				<!--- nothing found ... invalid ... --->
				<cfset StructClear(session) />
				<cfcookie name="ib_session_key" value="">						
	
				<cfreturn false />
		</cfif>
		
		<!--- check if session is opened ... --->
		<cfset a_bol_session_is_open = IsSessionOpen(sessionkey = a_str_sessionkey,
											applicationname = arguments.applicationname,
											ip = arguments.ip) />

		<cfif NOT a_bol_session_is_open>
			<!--- no session is open ... clear scope and exit --->
			<cfset StructClear(session) />
			<cfcookie name="ib_session_key" value="">
			
			<cfreturn false />
		</cfif>
		
		<!--- fullfill checks ... --->
		<cfif a_bol_session_is_open AND NOT StructKeyExists(arguments.request_scope, 'stSecurityContext')>
			<!--- session is open but does not exist in request scope ... --->
			
			<!--- get userkey ... --->
			<cfset a_str_userkey = GetUserkeyFromSessionkey(sessionkey = a_str_sessionkey) />
			
			<cfif Len(a_str_userkey) IS 0>
				<cfset StructClear(session) />
				<cfcookie name="ib_session_key" value="">			
			
				<cfreturn false />
			</cfif>
			
			<!--- get session data structure --->
			<cfset a_struct_session_data = GetSessionStructData(sessionkey = a_str_sessionkey) />

			<cfloop list="#StructKeyList(a_struct_session_data)#" delimiters="," index="a_str_item">
				<!--- set the data in the request and session scope ... --->
				<cfset session[a_str_item] = a_struct_session_data[a_str_item] />
			</cfloop>

			<!--- set the session key again ... --->		
			<cfset session.a_str_sessionkey = a_str_sessionkey />
			
			<cflock scope="session" timeout="30" type="readonly">
				<cfset CopyUserStructuresFromSession2RequestScope() />
			</cflock>
					
		</cfif>
		
		<cfset a_bol_result = true />
		
		<cfif arguments.setclientcookies>
			<cfcookie name="CFTOKEN" value="#client.CFToken#">
			<cfcookie name="CFID" value="#client.CFID#">
		</cfif>
		
		<!--- update timeout ... --->
		<cfset a_bol_update = UpdateSessionKeyTimeOut(sessionkey = a_str_sessionkey,
										applicationname = arguments.applicationname,
										ip = arguments.ip) />
	
		<cfreturn a_bol_result />
	</cffunction>
	
	<cffunction access="public" name="CreateInternalSessionVars" output="false" returntype="struct"
			hint="return struct for internal session vars ...">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of user">
			
		<cfset var stReturn = StructNew() />	
		<cfset var q_select_user = application.components.cmp_user.GetUserData(arguments.userkey) />
		
		<!--- return empty struct? ... --->
		<cfif q_select_user.recordcount IS 0>
			<cfreturn stReturn />
		</cfif>
		
		<cfinclude template="utils/session/inc_set_internal_session_vars.cfm">
		
		<cfreturn stReturn />

	</cffunction>
	
	<cffunction access="public" name="UpdateLastLoginAndLoginCount" output="false" returntype="boolean"
			hint="update last login and login count of user ...">
		<cfargument name="userkey" type="string" required="false">
		<cfargument name="remote_ip" type="string" required="false" default="#cgi.REMOTE_ADDR#"
			hint="ip address">
		
		<cfinclude template="queries/session/q_update_last_login.cfm">
		
		<cfreturn true />	

	</cffunction>

</cfcomponent>


