<!--- //

	Module:		CRM
	Function:	GetContactActitivitesData
	Description:Return activities


// --->



<cfswitch expression="#arguments.area#">
	<cfcase value="appointments">

		<cfset a_struct_filter_calendar.date_start = DateAdd('yyyy', -10, Now()) />
		<cfset a_struct_filter_calendar.date_end = DateAdd('yyyy', 10, Now()) />

		<cfset a_struct_output_cal = GetItemActivitiesAndData(type = 'appointments',
										securitycontext = arguments.securitycontext,
										usersettings = arguments.usersettings,
										contactkeys = arguments.entrykeys,
										filter = a_struct_filter_calendar)>

		<cfset stReturn.recordcount = a_struct_output_cal.recordcount />
		<cfset stReturn.output = a_struct_output_cal.a_str_content />
	</cfcase>
	<cfcase value="tasks">



		<cfset a_str_output_tasks = GetItemActivitiesAndData(type = 'tasks',
											securitycontext = arguments.securitycontext,
											usersettings = arguments.usersettings,
											contactkeys = arguments.entrykeys,
											filter = a_struct_filter_tasks) />

		<cfset stReturn.recordcount = a_str_output_tasks.recordcount />
		<cfset stReturn.output = a_str_output_tasks.a_str_content />

	</cfcase>
	<cfcase value="followups">



	</cfcase>
	<cfcase value="activities">

		<!--- all combined ... emails--->
		<cfinclude template="inc_generate_output_activities.cfm">

		<!--- closed followups ... --->

		<cfset a_struct_filter_followups.display_border = false />

		<cfset a_str_output_followups = GetItemActivitiesAndData(type = 'followups',
											securitycontext = arguments.securitycontext,
											usersettings = arguments.usersettings,
											contactkeys = arguments.entrykeys,
											filter = a_struct_filter_followups) />

		<cfset stReturn.recordcount = 5 />
		<cfset stReturn.output = stReturn.output & a_str_output_followups.a_str_content />

	</cfcase>
	<cfcase value="telephonecalls">
		<cfinclude template="inc_generate_output_telephonecalls.cfm">
	</cfcase>
	<cfcase value="newsletter">
		<cfinclude template="inc_generate_output_newsletter.cfm">
	</cfcase>
	<cfcase value="admin">
		<cfinclude template="inc_generate_output_admin.cfm">
	</cfcase>
</cfswitch>
<cfset stReturn.a = 123>

