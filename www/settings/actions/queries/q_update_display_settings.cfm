<!--- //

	Module:		Settings
	Description:Update display settings




	(time zone, day start, day end, number of emails to display, ...)


	scope: request,form

// --->

<cfif StructKeyExists(form,  'frmCBAutoClearTrashCanOnLogout')>
	<cfset a_int_autoCleanTrash = 1>
<cfelse>
	<cfset a_int_autoCleanTrash = 0>
</cfif>

<cfif StructKeyExists(form,  'frmCBConfirmLogout')>
	<cfset a_int_confirmlogout = 1>
<cfelse>
	<cfset a_int_confirmlogout = 0>
</cfif>

<cfquery name="q_update_settings">
UPDATE
	users
SET
	utcdiff = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmtimeZone)#">,
	daylightsavinghours = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmdaylightsavinghours#">,
	DisplayCalStartWith = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmCalendarDefaultView)#">,
	DAY_START_HOUR = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmCalendarStartHour)#">,
	DAY_END_HOUR = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmCalendarEndHour)#">,
	confirmlogout = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_confirmlogout#">
WHERE
	(entrykey = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.stSecurityContext.myuserkey#">)
;
</cfquery>

