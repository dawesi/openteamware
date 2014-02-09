<!--- //

	Module:		Forum
	Action:		doPostBackgroundAction
	Description: 
	

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
	
	<cfcase value="SubscribeAlertOnChange">
			
		<cfinvoke component="#a_cmp_forum#" method="CreateOnChangeAlert" returnvariable="a_bol_return_2">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="forumkey" value="#a_struct_parse.data.forumkey#">
			<cfinvokeargument name="threadkey" value="#a_struct_parse.data.threadkey#">
		</cfinvoke>
		
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangValJS('crm_ph_remote_edit_request_has_been_sent')#</cfoutput>', true);
		</script>
		
	</cfcase>
</cfswitch>

