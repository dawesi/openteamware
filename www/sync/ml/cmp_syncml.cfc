<!--- //

	Module:		WebDAV Component for SyncML Service
	Description: 
	

// --->
<cfcomponent output=false>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfsetting requesttimeout="20000">
	
	<!--- is this username a virtual user
	
		virtual users contain just a number combination
		
		--->
	<cffunction access="public" name="IsVirtualUser" returntype="boolean" output="false">
		<cfargument name="username" type="string" required="yes">
		
		<cfset var q_select_is_virtual_user = 0 />
		
		<cfinclude template="queries/q_select_is_virtual_user.cfm">
		
		<cfreturn (Len(q_select_is_virtual_user.userkey) GT 0) />
	</cffunction>
	
	<!--- return the real username by the virtual username ... --->
	<cffunction access="public" name="GetRealUsernameByVirtualUser" returntype="string" output="false">
		<cfargument name="username" type="string" required="yes" hint="username ...">
		
		<cfset var q_select_real_username_by_virtual_username = 0 />
		
		<cfinclude template="queries/q_select_real_username_by_virtual_username.cfm">
		
		<cfreturn q_select_real_username_by_virtual_username.username />
	</cffunction>
	
	<cffunction access="remote" name="CheckLogin" returntype="struct" output="false">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfset var a_struct_login = StructNew() />
		
		<cfinvoke component="/components/management/users/cmp_check_login" argumentcollection="#arguments#" method="CheckLogin" returnvariable="a_struct_login"/>
		
		<cfreturn a_struct_login />
	</cffunction>
	
	<cffunction access="remote" name="GetSecurityContext" returntype="struct" output="false">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfset var stSecurityContext = StructNew() />
		
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
		
		<cfreturn stSecurityContext />
		
	</cffunction>
	
	<cffunction access="remote" name="GetUserSettings" returntype="struct" output="false">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfset var stReturn = StructNew() />
		
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
		
		<cfreturn stReturn />
		
	</cffunction>
</cfcomponent>


