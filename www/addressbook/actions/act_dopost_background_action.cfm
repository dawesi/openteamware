<!--- //

	Module:		AddressBook
	Action:		doPostBackgroundAction
	Description:General routine for background actions
	
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
	<cfcase  value="EnableRemoteRequest">
		
		<cfloop list="#a_struct_parse.data.entrykeys#" index="sEntrykey">
		
			<cfinvoke component="#application.components.cmp_addressbook#" method="ActivateRemoteEdit" returnvariable="stReturn">
				<cfinvokeargument name="entrykey" value="#sEntrykey#">
				<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
				<cfinvokeargument name="usersettings" value="#request.stUserSettings#">		
				<cfinvokeargument name="forcenewsend" value="false">
				<cfinvokeargument name="ownintromsg" value="#a_struct_parse.data.msg#">
			</cfinvoke>
		
		</cfloop>
		
		<!--- send remote edit ... --->
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangValJS('crm_ph_remote_edit_request_has_been_sent')#</cfoutput>', true);
		</script>
		
	</cfcase>
	<cfcase value="UpdateLastContact">
		
		<!--- update last contact ... --->
		<cfinclude template="utils/inc_update_last_contact.cfm">
		<script type="text/javascript">
			DisplayStatusInformation('<cfoutput>#GetLangValJS('crm_ph_last_contact_has_been_updated')#'</cfoutput>, true);
		</script>
		
	</cfcase>
	<cfcase value="CancelRemoteEditJob">
		
		<!--- cancel remote edit job ... --->
	</cfcase>
	<cfcase value="DoSimpleDupCheck">
		
		<!--- do a simple dup check ... --->
		<cfinclude template="utils/inc_do_background_check.cfm">
		
	</cfcase>
	<cfcase value="DoCreateAccountForContact">
		
		<cfinclude template="utils/inc_do_create_account_for_contact.cfm">
		
	</cfcase>
	<cfcase value="AddFilterCriteria">
	
		<!--- add filter criteria ... --->
		<cfset a_struct_data = a_struct_parse.data />
		
		<!--- default ... IS ... --->
		<cfset a_str_operator = 0 />
		
		<cfset a_str_display_name = '' />
		
		<cfswitch expression="#a_struct_data.fieldname#">
			<cfcase value="criteria">
				<cfset a_str_operator = 6 />
				<cfset a_str_display_name = GetLangVal('crm_wd_criteria') />
			</cfcase>
			<cfcase value="workgroup">
				<cfset a_str_display_name = GetLangVal('cm_wd_workgroup') />
			</cfcase>
			<cfcase value="categories">
				<cfset a_str_display_name = GetLangVal('adrb_wd_category') />
			</cfcase>			
		</cfswitch>
		 
		<cfinvoke component="#application.components.cmp_crmsales#" method="AddFilterSearchCriteria" returnvariable="a_bol_return">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
			<cfinvokeargument name="viewkey" value="#a_struct_data.viewkey#">
			<cfinvokeargument name="area" value="#a_struct_data.area#">
			<cfinvokeargument name="connector" value="0">
			<cfinvokeargument name="operator" value="#a_str_operator#">
			<!--- automatically calculated --->
			<cfinvokeargument name="displayname" value="#a_str_display_name#">
			<cfinvokeargument name="internalfieldname" value="#a_struct_data.fieldname#">
			<cfinvokeargument name="comparevalue" value="#a_struct_data.data#">
			<!--- always 0 ... not good! --->
			<cfinvokeargument name="internaldatatype" value="0">
		</cfinvoke>
	
	</cfcase>
	<cfdefaultcase>
	</cfdefaultcase>
</cfswitch>

