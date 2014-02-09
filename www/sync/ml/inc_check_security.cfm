<cftry>
	<cflogin>
		<cfset request.a_struct_action.a_str_password = cflogin.password>
	</cflogin>
<cfcatch type="any"></cfcatch></cftry>

<!--- // check if the user is a virtual user ... and if yes, get the real username ... //--->

<cflog text="----------- new request: username = request.a_struct_action.a_str_username: username = #request.a_struct_action.a_str_username#" type="Information" log="Application" file="ib_syncml">

<cfset a_bol_is_virtual_user = request.a_ws_syncml.IsVirtualUser(username = request.a_struct_action.a_str_username)>

<cflog text="a_bol_is_virtual_user: #a_bol_is_virtual_user#" type="Information" log="Application" file="ib_syncml">

<cfif a_bol_is_virtual_user>
	<cfset request.a_struct_action.a_str_virtual_username = request.a_struct_action.a_str_username>
	
	<!--- get real username  now ... --->
	<cfset request.a_struct_action.a_str_username = request.a_ws_syncml.GetRealUsernameByVirtualUser(username = request.a_struct_action.a_str_username)>
<cfelse>
	<cfset request.a_struct_action.a_str_virtual_username = ''>
</cfif>

<cflog text="new username after checking: #request.a_struct_action.a_str_username#" type="Information" log="Application" file="ib_syncml">

<!--- check login ... provide username/password --->
<cfset a_struct_login_check = request.a_ws_syncml.CheckLogin(username = request.a_struct_action.a_str_username, password = request.a_struct_action.a_str_password)>

<cfif a_struct_login_check.ok>

	<!--- get securitycontext ... --->
	<cfset request.a_struct_security_context = request.a_ws_syncml.getSecurityContext(username = request.a_struct_action.a_str_username, password = request.a_struct_action.a_str_password)>
	<!--- get user settings ... --->
	<cfset request.stUserSettings = request.a_ws_syncml.GetUserSettings(username = request.a_struct_action.a_str_username, password = request.a_struct_action.a_str_password)>

	<!--- get device settings ... --->
	<cfif Len(request.a_struct_action.a_str_virtual_username) GT 0>
	
		<cfinvoke component="#request.a_str_component_mobilesync#" method="GetDevicesOfUser" returnvariable="q_select_devices">
			<cfinvokeargument name="userkey" value="#request.a_struct_security_context.myuserkey#">
		</cfinvoke>
				
		<cfquery name="q_select_device" dbtype="query">
		SELECT
			*
		FROM
			q_select_devices
		WHERE
			virtual_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_virtual_username#">
		;
		</cfquery>
		
		<cfset request.q_select_device = q_select_device>
	
	</cfif>
	
<cfelse>

	<!--- log failure and inform user about it ... --->
	<cfquery name="q_update_login_failed" datasource="#request.a_str_db_users#">
	UPDATE
		virtual_mobilesync_users
	SET
		loginfailed = 1,
		dt_login_failed = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	WHERE
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_virtual_username#">
	;
	</cfquery>
	
	<!--- code 401 should be returned --->
	<cfheader statuscode="401">
	<!---<cfthrow message="Security Error" detail="Authentication of the user '#request.a_struct_action.a_str_username#' failed"/>--->
	
	<cfabort>

</cfif>