<!--- //

	Module:		EMail
	Action:		doPostBackgroundAction
	Description:General routine for background actions
	

// --->

<!--- the desired action ... --->
<cfparam name="form.FRMACTION" type="string" default="">

<!--- the XML document containing the request ... --->
<cfparam name="form.FRMREQUEST" type="string" default="">

<cfset a_struct_parse = application.components.cmp_tools.ParseBackgroundOperationRequest(form.frmrequest) />

<!--- output error ... --->
<cfif NOT a_struct_parse.result>
	<script type="text/javascript">
		OpenErrorMessagePopup('<cfoutput>#Val(a_struct_parse.error)#</cfoutput>');
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfswitch expression="#form.FRMACTION#">
	<cfcase value="SendQuickReply">
		<!--- send a quick reply --->

		<script type="text/javascript">
			alert('hello from quickreply - not working yet');
		</script>
		<cfexit method="exittemplate">
		<cfinclude template="utils/inc_send_quick_reply.cfm">
		
	</cfcase>
	<cfcase value="FlagMessage">
		<!--- (un) flag message --->
		
		
	</cfcase>
	<cfcase value="reportasspamanddelete">
		<!--- report as spam, create filter and delete msg --->
		
		
	</cfcase>
	<cfcase value="shortaddtoaddressbook">
		<!--- quickly add to address book --->
	
	</cfcase>
	<cfcase value="DeleteMessage">
		
		<!--- delete a message ... --->
		<cfinclude template="utils/act_delete_message.cfm">
		
	</cfcase>
	
	<cfcase value="MoveMessage">
		
		<!--- move a message --->
		<cfinclude template="utils/act_move_message.cfm">
		
	</cfcase>

</cfswitch>


