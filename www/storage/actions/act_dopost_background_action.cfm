<!--- //

	Module:		Storage
	Action:		doPostBackgroundAction
	Description: 
	

// --->


<cfprocessingdirective pageencoding="UTf-8">

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
	<cfcase  value="DoCreateExclusiveLock">
	
	<!--- create an exlusive file lock ... --->
	<cfinvoke component="#application.components.cmp_locks#" method="CreateExclusiveLock" returnvariable="stReturn_lock">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="objectkey" value="#a_struct_parse.data.entrykey#">
		<cfinvokeargument name="timeout_minutes" value="#a_struct_parse.data.duration#">
		<cfinvokeargument name="comment" value="#a_struct_parse.data.comment#">
	</cfinvoke>
	
	<cfif stReturn_lock.result>
	
	<cfelse>
	
	</cfif>
	
	<script type="text/javascript">
	CloseSimpleModalDialog();
	</script>
	
	</cfcase>
	
	<cfcase value="DoRemoveExclusiveLock">

	<cfinvoke component="#application.components.cmp_locks#" method="RemoveExclusiveLock" returnvariable="stReturn_lock">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="objectkey" value="#a_struct_parse.data.entrykey#">
	</cfinvoke>
		
	<script type="text/javascript">
	CloseSimpleModalDialog();
	</script>
	
	</cfcase>
</cfswitch>


