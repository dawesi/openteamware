<!--- //
	Module:		 Calendar
	Action:		 doPostBackgroundAction
	Description: General routine for background actions
// --->

<!--- the desired action ... --->
<cfparam name="form.FRMACTION" type="string" default="">

<!--- the XML document containing the request ... --->
<cfparam name="form.FRMREQUEST" type="string" default="">

<cfset a_struct_parse = application.components.cmp_tools.ParseBackgroundOperationRequest(form.frmrequest)>

<!--- output error ... --->
<cfif NOT a_struct_parse.result>
	<script type="text/javascript">
		OpenErrorMessagePopup('<cfoutput>#Val(a_struct_parse.error)#</cfoutput>');
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfswitch expression="#form.FRMACTION#">
	<cfcase value="SetSendInvitationFlag">
        <!--- call component to update the database field --->
		<cfinvoke component="#application.components.cmp_calendar#" method="SetSendInvitationFlag">
			<cfinvokeargument name="eventkey" value="#a_struct_parse.data.eventkey#">
			<cfinvokeargument name="type" value="#a_struct_parse.data.type#">
			<cfinvokeargument name="parameter" value="#a_struct_parse.data.parameter#">
			<cfinvokeargument name="sendinvitation" value="#a_struct_parse.data.checked#">
		</cfinvoke>
		
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangVal('cal_wd_status_changed')#</cfoutput>', true);
		</script>

	</cfcase>
	<cfcase value="SetVirtualCalendarsFilter">
	
		<!--- save preference ... --->
		<cfmodule template="/common/person/saveuserpref.cfm"
        		entrysection = "calendar"
		        entryname = "calendar.virtualcalendarfilter"
        		entryvalue1 = #a_struct_parse.data.virtualcalendarkeys#>
		
		<script type="text/javascript">
		    window.location.reload();
		</script>
	
	</cfcase>

	<cfcase value="UseLocationOfContact">
		
		<!--- TODO hp: use loc of selected contact as event loc ... --->
		
	
	</cfcase>
	
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>
