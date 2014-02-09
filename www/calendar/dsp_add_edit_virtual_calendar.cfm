<!--- //

	Module:		Calendar
	Action:		AddVirtualCalendar
	Description:Allow the user to create a virtual calendar
	

// --->
<cfparam name="url.entrykey" type="string" default="">

<cfset variables.a_cmp_forms = application.components.cmp_forms>
<cfset VirtualCalendarAction = 'create'>
<cfset q_select_virtual_calendar = QueryNew('')>

<!--- if updating then load the values from database --->
<cfif Len(url.entrykey) GT 0 > 
	<cfset VirtualCalendarAction = 'edit'>
	<cfinvoke component="#application.components.cmp_calendar#" method="GetVirtualCalendarOfUser" returnvariable="stReturn">
		<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
		<cfinvokeargument name="virtualcalendarkey" value="#url.entrykey#">
	</cfinvoke>

	<cfif NOT stReturn.result>
		<cflocation url="default.cfm?action=VirtualCalendars&ibxerrorno=#stReturn.error#">
	</cfif>

	<cfset q_select_virtual_calendar = stReturn.q_select_virtual_calendar>
</cfif>

<!--- display the form --->
<cfset a_str_form = a_cmp_forms.DisplaySavedForm(action = VirtualCalendarAction,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						query = q_select_virtual_calendar,
						entrykey = '06416CCA-9C64-D99E-87D50A76C0667C0D')>
<cfoutput>#a_str_form#</cfoutput>

