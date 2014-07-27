<!--- //

	Module:		Address Book
	Action:		Update item
	Description:Call update method for an account, contact or lead
	
// --->

<cfparam name="form.frmworkgroupkeys" type="string" default="">
<cfparam name="form.frmassigned_users" type="string" default="">

<cfinvoke component="#application.components.cmp_forms#" method="CollectFormValues" returnvariable="stReturn">
	<cfinvokeargument name="requestkey" value="#form.frmRequestEntrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="form_scope" value="#form#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="newvalues" value="#stReturn.A_STRUCT_DATABASE_FIELDS#">
</cfinvoke>

<!--- check for error ... --->
<cfif NOT stReturn.result>
	<h1><cfoutput>Error: #stReturn.error#</cfoutput></h1>
	<cfexit method="exittemplate">
</cfif>

<cfif Len(form.frmprivatenotices) GT 0>
	<!--- update private comment --->
	<cfmodule template="/common/person/saveuserpref.cfm"
		entrysection = "crm.contact.owncomment"
		entryname = "#a_str_contactkey#"
		entryvalue1 = #form.frmprivatenotices#>	
</cfif>

<!--- workgroups ... --->
<cfset q_select_wg_shares = application.components.cmp_security.GetWorkgroupSharesForObject(securitycontext = request.stSecurityContext,
													servicekey = request.sCurrentServiceKey,
													entrykey = form.frmentrykey) />
													
<cfloop query="q_select_wg_shares">
	<cfset application.components.cmp_security.RemoveWorkgroupShare(securitycontext = request.stSecurityContext,
									servicekey = request.sCurrentServiceKey,
									entrykey = form.frmentrykey,
									workgroupkey = q_select_wg_shares.workgroupkey) />
</cfloop>
<cfloop list="#form.frmworkgroupkeys#" delimiters="," index="a_str_workgroupkey">
	
	<cfinvoke component="#application.components.cmp_security#" method="CreateWorkgroupShare" returnvariable="stReturn">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="workgroupkey" value="#a_str_workgroupkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	</cfinvoke>
	
</cfloop>

<!--- assignments ... --->
<cfinvoke component="#application.components.cmp_assigned_items#" method="RemoveAllAssignments" returnvariable="stReturn_remove_assignments">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="objectkey" value="#form.frmentrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>

<cfloop list="#form.frmassigned_users#" index="a_str_assigned_userkey">

	<cfinvoke component="#application.components.cmp_assigned_items#" method="AddAssignment" returnvariable="a_bol_return">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="objectkey" value="#form.frmentrykey#">
		<cfinvokeargument name="userkey" value="#a_str_assigned_userkey#">
		<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>

</cfloop>

<cflocation addtoken="false" url="index.cfm?action=ShowItem&entrykey=#form.frmentrykey#">
