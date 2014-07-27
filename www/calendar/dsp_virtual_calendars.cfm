<!--- //

	Module:		Calendar
	Action:		VirtualCalendars
	Description:	give the user the possibility to include more calendards

	they are simple "linked" into the user calendar

	and display together with the other events.

	see also www.apple.com/ical


// --->

<cfset SetHeaderTopInfoString(GetLangVal('cal_wd_calendars'))>

<cfinvoke component="#application.components.cmp_calendar#" method="GetVirtualCalendarsOfUser" returnvariable="q_select_virtual_calendars">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfsavecontent variable="a_str_content">
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td></td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td colspan="2">
			<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
		</td>
	</tr>
	<cfoutput query="q_select_virtual_calendars">
		<tr>
			<td style="width:20px;">
				<span style="background-color:#q_select_virtual_calendars.colour#;height:10px;width:20px;">
					<img src="/images/space_1_1.gif" width="10px" />
				</span>
			<td>
				#htmleditformat(q_select_virtual_calendars.title)#
			</td>
			<td>
				#htmleditformat(q_select_virtual_calendars.description)#
			</td>
			<td>
				<a href="index.cfm?action=AddEditVirtualCalendar&entrykey=#q_select_virtual_calendars.entrykey#"><img src="/images/si/pencil.png" class="si_img" /></a>

				<a href="##" onclick="ConfirmDeleteVirtualCalendar('#jsstringformat(q_select_virtual_calendars.entrykey)#', '#jsstringformat(q_select_virtual_calendars.title)#');return false;"><span class="glyphicon glyphicon-trash"></span></a>
			</td>
		</tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<input type="button" value="<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>" onclick="GotoLocHref('index.cfm?action=AddEditVirtualCalendar');" class="btn btn-primary" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cal_wd_own_calendars'), a_str_buttons, a_str_content)#</cfoutput>

<cfinvoke component="#application.components.cmp_calendar#" method="GetPublicVirtualCalendars" returnvariable="q_select_public_virtual_calendars"/>
<cfinvoke component="#application.components.cmp_calendar#" method="GetVirtualCalendarSubscriptionsAsQuery" returnvariable="q_select_virtual_calendars_subscriptions">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfif q_select_public_virtual_calendars.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_subscriptions_calendarkeys = valuelist(q_select_virtual_calendars_subscriptions.virtualcalendarkey)>
<table>
	<tr>
		<td>
			<cfoutput>#GetLangVal('cm_wd_title')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td></td>
	</tr>
	<cfoutput query="q_select_public_virtual_calendars">
		<cfif q_select_public_virtual_calendars.userkey NEQ request.stSecurityContext.myuserkey>
			<tr>
				<td>#htmleditformat(q_select_public_virtual_calendars.title)#</td>
				<td>#htmleditformat(q_select_public_virtual_calendars.description)#</td>
				<td>
					<cfif ListFindNoCase(a_str_subscriptions_calendarkeys, q_select_public_virtual_calendars.entrykey) EQ 0>
						<a href="act_subscribe_to_public_calendar.cfm?entrykey=#q_select_public_virtual_calendars.entrykey#">subscribe</a></td>
					<cfelse>
						<cfquery name="q_select_subscription_entrykey" dbtype="query">
							select entrykey from q_select_virtual_calendars_subscriptions where virtualcalendarkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_public_virtual_calendars.entrykey#">
						</cfquery>
						<a href="##" onclick="ConfirmUnsubscribeFromVirtualCalendar('#jsstringformat(valuelist(q_select_subscription_entrykey.entrykey))#'); return false;">unsubscribe</a>
					</cfif>
				</td>
			</tr>
		</cfif>
	</cfoutput>
</table>

