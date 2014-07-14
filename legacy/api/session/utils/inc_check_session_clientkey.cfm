<!--- select the userkey by the clientkey --->
<cfquery name="q_select_userkey_by_clientkey" datasource="#request.a_str_db_users#">
SELECT
	userkey
FROM
	webservices_enabled_applications
WHERE
	clientkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientkey#">
;
</cfquery>
				
<cfif q_select_userkey_by_clientkey.recordcount IS 0>
	<cfset stReturn.error = 530>
	<cfset stReturn.errormessage = 'User does not exist (any more).'>
	<cfreturn GenerateReturnXMLDocumentFromReturnStructure(stReturn)>
</cfif>
		
<!--- user ok? --->
<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stSecurityContext">
	<cfinvokeargument name="userkey" value="#q_select_userkey_by_clientkey.userkey#">
</cfinvoke>
		
<cfset application.directaccess.securitycontext[arguments.clientkey] = stSecurityContext>
		
<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#q_select_userkey_by_clientkey.userkey#">
</cfinvoke>
		
<cfset application.directaccess.usersettings[arguments.clientkey] = stUserSettings>		