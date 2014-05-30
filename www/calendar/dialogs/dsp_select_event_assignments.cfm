<!--- //
	Module:		Calendar
	Action:		AssignNewElementToAppointment
	Description:select resources/contacts or workmates that will be assigned to event
	

	
// --->

<!--- entrykey of virtual calendar ... --->
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.type" type="integer" default="">

<!--- get entrykeys of the assigned elements --->
<cfif Len(url.entrykey) GT 0>
	
	<!--- TODO hansjp: use app.cmp ... --->
	<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
        <cfinvokeargument name="temporary" value="true">
	</cfinvoke>
	
	<cfquery name="q_select_assignments" dbtype="query">
	SELECT
		parameter
	FROM
		q_select_meeting_members
	WHERE
		type = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.type#">
	;
	</cfquery>
	
	<cfset a_str_assigned_entrykeys = ValueList(q_select_assignments.parameter) />
<cfelse>
	<cfset a_str_assigned_entrykeys = '' />
</cfif>

<!--- render the form only for single address and resource --->
<cfif url.type EQ 2 or url.type EQ 4>
	<form name="formSelectElements">
		<cfoutput>
		<input type="hidden" name="frmentrykey" value="#url.entrykey#" />
		<input type="hidden" name="frmtype" value="#url.type#" />
		</cfoutput>
</cfif>

<cfswitch expression="#url.type#">
	<cfcase value="0">
		<cfinclude template="dsp_inc_select_event_assignments_employees.cfm">
	</cfcase>
	<cfcase value="1">
		<cfinclude template="dsp_inc_show_select_addressbook.cfm">
	</cfcase>
	<cfcase value="2">
		<cfinclude template="dsp_inc_select_event_assignments_email_address.cfm">
	</cfcase>
	<cfcase value="4">
		<cfinclude template="dsp_inc_show_select_resources.cfm">
	</cfcase>
</cfswitch>

<!--- render the buttons and close the form only for single address and resource --->
<cfif url.type EQ 2 or url.type EQ 4>
	<br /> 
		<input type="button" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>" class="btn btn-primary" onclick="DoAssignElements();" />
		<input type="button" value="<cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput>" class="btn" onclick="CloseSimpleModalDialog();" />
	</form>
</cfif>

