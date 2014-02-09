
<cfcomponent displayname="InBoxccSession" hint="Session Management (Login/Logout)">

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">

	<cfif NOT StructKeyExists(application, 'webdav')>
		<cfset application.webdav = StructNew()>
		<cfset application.webdav.securitycontext = StructNew()>
		<cfset application.webdav.usersettings = StructNew()>		
	</cfif>
	
	<cfif NOT StructKeyExists(application, 'webservices_access')>
		<cfset application.webservices_access = StructNew()>
		<cfset application.webservices_access.securitycontext = StructNew()>
		<cfset application.webservices_access.usersettings = StructNew()>		
	</cfif>	

	<cffunction access="remote" name="Logout" output="false" returntype="struct">
		<cfargument name="sessionkey" required="false" type="string" default="" displayname="The session key">
		
		<cfreturn StructNew()>
		
	</cffunction>
	
	<!--- check if a session exists --->
	<cffunction access="remote" name="IsSessionActive" returntype="boolean" output="false">
		<cfargument name="sessionkey" type="string" required="yes">
		
		<cfreturn StructKeyExists(application.webdav.securitycontext, arguments.sessionkey)>
	</cffunction>
	
	<!--- get the session key --->
	<cffunction access="remote" name="GetSessionKey" output="false" returntype="string" displayname="Login and get a session key">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="applicationkey" type="string" required="yes">
				
		<cfset a_str_session_key = CreateUUID()>
		
		<cfset a_tmp_struct_sec_context = GetSecurityContext(username=arguments.username,password=arguments.password,sessionkey=a_str_session_key)>
		<cfset a_tmp_struct_usersettings = GetUserSettings(username=arguments.username,password=arguments.password,sessionkey=a_str_session_key)>
	
		<cfreturn a_str_session_key>
	</cffunction>
	
	<cffunction access="remote" name="GetSecurityContext" output="false" returntype="struct">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="sessionkey" type="string" required="yes">
		
		<!--- check if already exists ... --->
		<cfif StructKeyExists(application.webdav.securitycontext, arguments.sessionkey)>
			<cfreturn application.webdav.securitycontext[arguments.sessionkey]>
		</cfif>
		
		<cfquery name="q_select_userkey" datasource="#request.a_str_db_users#">
		SELECT
			entrykey
		FROM
			users
		WHERE
			username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
			AND
			pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
		;
		</cfquery>
		
		<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stSecurityContext">
			<cfinvokeargument name="userkey" value="#q_select_userkey.entrykey#">
		</cfinvoke>
		
		<cfset application.webdav.securitycontext[arguments.sessionkey] = stSecurityContext>
		
		<cfreturn stSecurityContext>
	</cffunction>
	
	<cffunction name="GetUserSettings" output="false" returntype="struct" access="remote">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="sessionkey" type="string" required="yes">
		
		<!--- check if already exists ... --->
		<cfif StructKeyExists(application.webdav.usersettings, arguments.sessionkey)>
			<cfreturn application.webdav.usersettings[arguments.sessionkey]>
		</cfif>		
		
		<cfquery name="q_select_userkey" datasource="#request.a_str_db_users#">
		SELECT
			entrykey
		FROM
			users
		WHERE
			username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
			AND
			pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
		;
		</cfquery>
		
		<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn">
			<cfinvokeargument name="userkey" value="#q_select_userkey.entrykey#">
		</cfinvoke>
		
		<cfset application.webdav.usersettings[arguments.sessionkey] = stReturn>
		
		<cfreturn stReturn>
		
	</cffunction>

</cfcomponent>