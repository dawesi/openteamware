<!--- //

	Service:	CRM
	Action:		doPostBackgroundAction
	Description:Execute a background action
	
	Header:	

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

<cfswitch expression="#form.frmaction#">
	<cfcase value="CreateHistoryItemNotReached">
		<!--- create a history item (not reached) ... --->
		<cfset a_str_contactkey = a_struct_parse.data.contactkey />
		
		<cfinvoke component="#application.components.cmp_crmsales#" method="CreateHistoryItem" returnvariable="stReturn">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
			<cfinvokeargument name="objectkey" value="#a_str_contactkey#">
			<cfinvokeargument name="item_type" value="5">
			<cfinvokeargument name="dt_created" value="#GetODBCUTCNow()#">
		</cfinvoke>
		
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_item_has_been_created')#</cfoutput>', true);
		</script>
		
	</cfcase>
	<cfcase value="SetFollowUpDone">
		<!--- set a follow up job status to done ... --->
		<cfset a_struct_newvalues = StructNew() />
		<cfset a_struct_newvalues.done = 1 />
		
		<cftry>
		
		<cfinvoke component="#request.a_str_component_followups#" method="UpdateFollowup" returnvariable="a_bol_return">
			<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="entrykey" value="#a_struct_parse.data.entrykey#">
			<cfinvokeargument name="objectkey" value="#a_struct_parse.data.objectkey#">				
			<cfinvokeargument name="newvalues" value="#a_struct_newvalues#">
		</cfinvoke>
		
		<cfcatch type="any">
			<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="test" type="html">
			<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>
		
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_item_has_been_created')#</cfoutput>', true);
		</script>		
		
	</cfcase>
	<cfdefaultcase>
		
	</cfdefaultcase>
</cfswitch>

