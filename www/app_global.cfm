<cfsetting enablecfoutputonly="Yes">
<!--- //

	Module:        Application
	Description:   Global include (which includes global util files like language, variables ...)
	
// --->

<!--- database source namens --->
<cfinclude template="/common/app/app_global.cfm">

<!--- translation --->
<cfinclude template="/common/app/inc_lang.cfm">

<!--- various scripts --->
<cfinclude template="/common/scripts/script_utils.cfm">

<!--- copy basic structures (securitycontext, usersettings, ... not if disabled by non-session-management apps --->
<cfif NOT StructKeyExists(request, 'a_bol_session_management_disabled')>
	<cflock scope="session" timeout="30" type="readonly">		
		<cfset CopyUserStructuresFromSession2RequestScope() />
	</cflock>
</cfif>

<!--- the current service (for logging ... has to be set by each service ...) --->
<cfif NOT StructKeyExists(request, 'sCurrentServiceKey')>
	<cfset request.sCurrentServiceKey = '' />
</cfif>

<cfsetting enablecfoutputonly="No">