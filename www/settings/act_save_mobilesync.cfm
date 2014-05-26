<cfinclude template="../login/check_logged_in.cfm">

<!--- save the various mobile sync preference ... --->

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="index.cfm?action=mobilesync">	
</cfif>

<cfparam name="form.frm_cb_delete_online" type="numeric" default="0">

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "delete_data_online"
	entryvalue1 = #form.frm_cb_delete_online#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_addressbook"
	entryvalue1 = #form.frm_restrictions_addressbook#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar"
	entryvalue1 = #form.frm_restrictions_calendar#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar_timeframe"
	entryvalue1 = #form.frm_restrictions_calendar_timeframe#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_tasks"
	entryvalue1 = #form.frm_restrictions_tasks#>
	

<cflocation addtoken="no" url="index.cfm?action=mobilesync&saved=true">