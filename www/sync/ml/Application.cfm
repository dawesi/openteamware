<!--- //

	Module:		SyncML Service Application.cfm
	Description: 
	

// --->

<cfapplication name="ib_app_sync_syncml"
				clientmanagement="yes" sessionmanagement="no" setclientcookies="no" setdomaincookies="no">

<!--- allowed IPs --->
<cfif ListFindNoCase('62.99.232.51,81.223.48.140', cgi.REMOTE_ADDR) IS 0>
	Access denied.
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="invalid request ip" type="html">
	<cfdump var="#cgi#">
	<cfdump var="#GetHttpRequestData()#">
	</cfmail>
	<cfabort>
</cfif>

<cfset request.a_str_tc_begin = GetTickCount() />
<cfset request.a_str_log_entrykey = CreateUUID() />

<cfset request.a_struct_response_headers = StructNew() />

<cferror type="exception" template="log/log_exception.cfm">
<cfinclude template="inc_scripts.cfm">

<cfinclude template="/common/app/app_global.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cflock name="app_check_structures_exist" timeout="3" type="exclusive">

	<cfif NOT StructKeyExists(Application, 'securitycontext_structures')>
		<cfset Application.securitycontext_structures = StructNew() />
	</cfif>
	
	<cfif NOT StructKeyExists(Application, 'usersettings_structures')>
		<cfset Application.usersettings_structures = StructNew() />
	</cfif>

</cflock>

<!--- global variables --->
<cfset request.a_str_url_identifier_contacts = 'contacts' />
<cfset request.a_str_url_identifier_tasks = 'tasks' />
<cfset request.a_str_url_identifier_calendar = 'calendar' />
<cfset request.a_str_url_identifier_notes = 'notes' />

