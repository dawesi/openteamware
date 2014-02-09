<!--- //

	Module:		App for /jobs/
	Description: 
// --->

<cfapplication name="otwjobs"
	clientmanagement="yes"
	sessionmanagement="no" setclientcookies="no" setdomaincookies="no">

<cfset request.a_bol_session_management_disabled = true />

<!--- app_global includen --->
<cfinclude template="../app_global.cfm">

<!--- include common scripts library ... --->
<cfinclude template="/common/scripts/script_utils.cfm">