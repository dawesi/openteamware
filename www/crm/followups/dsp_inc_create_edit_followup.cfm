<!--- //

	Service:	CRM
	Action:		Create / Edit a follow up job
	Description:
	
	Header:	

// --->

<cfparam name="CreateEditFollowupJob.action" type="string" default="create">
<cfparam name="CreateEditFollowupJob.returnurl" type="string" default="">
<cfparam name="CreateEditFollowupJob.query" type="query" default="#QueryNew('userkey,alert_email,comment,priority,followuptype,entrykey,objecttitle,servicekey,objectkey,dt_due')#">
<cfset a_str_operation = CreateEditFollowupJob.action />

<!--- create a new follow up ... --->
<cfif CreateEditFollowupJob.action IS 'create'>
	<cfset tmp = QueryAddRow(CreateEditFollowupJob.query, 1)>
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'objecttitle', url.title) />
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'servicekey', url.servicekey) />
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'userkey', url.userkey) />
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'objectkey', url.objectkey) />
	
	<cfset a_dt_default = DateAdd('d', 7, Now()) />
	<cfset a_dt_default = CreateDate(Year(a_dt_default), Month(a_dt_default), Day(a_dt_default)) />
	
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'dt_due', a_dt_default) />
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'alert_email', 1) />
</cfif>

<!--- get assignments ... --->
<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="#CreateEditFollowupJob.query.servicekey#">
	<cfinvokeargument name="objectkeys" value="#CreateEditFollowupJob.query.objectkey#">
</cfinvoke>

<cfif CreateEditFollowupJob.action IS 'create' AND CreateEditFollowupJob.query.userkey IS request.stSecurityContext.myuserkey AND q_select_assignments.recordcount GT 0>
	<cfset QuerySetCell(CreateEditFollowupJob.query, 'userkey', q_select_assignments.userkey)>
</cfif>

<!--- get workgroup shares AND members of these groups (where the current user has access!) --->
<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#CreateEditFollowupJob.query.objectkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#CreateEditFollowupJob.query.servicekey#">
</cfinvoke>			

<cfset a_str_select_shares = ListAppend(ValueList(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key), 'dummy') />

<cfquery name="q_select_shares" dbtype="query">
SELECT
	*
FROM
	q_select_shares
WHERE
	workgroupkey IN (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#a_str_select_shares#">)
;
</cfquery>

<cfsavecontent variable="a_str_date_selector">
<cfset a_str_dt_one_week = DateFormat(DateAdd('d', 7, Now()), request.a_str_default_js_dt_format)>
		<cfset a_str_dt_two_weeks = DateFormat(DateAdd('d', 14, Now()), request.a_str_default_js_dt_format)>
		<cfset a_str_dt_one_month = DateFormat(DateAdd('m', 1, Now()), request.a_str_default_js_dt_format)>
		<cfset a_str_dt_two_months = DateFormat(DateAdd('m', 3, Now()), request.a_str_default_js_dt_format)>
		
		<cfoutput>#GetLangVal('cm_wd_in')#</cfoutput>
		<a href="#" onClick="document.forms.form_create_edit_followup.frmdt.value = '<cfoutput>#jsstringformat(a_str_dt_one_week)#</cfoutput>';"><cfoutput>#GetLangVal('crm_ph_followup_create_in_one_week')#</cfoutput></a> | 
		<a href="#" onClick="document.forms.form_create_edit_followup.frmdt.value = '<cfoutput>#jsstringformat(a_str_dt_two_weeks)#</cfoutput>';"><cfoutput>#GetLangVal('crm_ph_followup_create_in_two_weeks')#</cfoutput></a> | 
		<a href="#" onClick="document.forms.form_create_edit_followup.frmdt.value = '<cfoutput>#jsstringformat(a_str_dt_one_month)#</cfoutput>';"><cfoutput>#GetLangVal('crm_ph_followup_create_in_one_month')#</cfoutput></a> | 
		<a href="#" onClick="document.forms.form_create_edit_followup.frmdt.value = '<cfoutput>#jsstringformat(a_str_dt_two_months)#</cfoutput>';"><cfoutput>#GetLangVal('crm_ph_followup_create_in_three_months')#</cfoutput></a>

</cfsavecontent>


<!--- default values ... --->
<cfset a_struct_force_element_values = StructNew()>
<cfset a_struct_force_element_values.quicker_date_selection = a_str_date_selector />
<cfset a_struct_force_element_values.entrykey = CreateEditFollowupJob.query.entrykey />
<cfset a_struct_force_element_values.servicekey = CreateEditFollowupJob.query.servicekey />
<cfset a_struct_force_element_values.objectkey = CreateEditFollowupJob.query.objectkey />
<cfset a_struct_force_element_values.title = CreateEditFollowupJob.query.objecttitle />
<cfset a_struct_force_element_values.object_title_display = CreateEditFollowupJob.query.objecttitle />

<cfif Len(CreateEditFollowupJob.returnurl) GT 0>
	<cfset a_struct_force_element_values.returnurl = CreateEditFollowupJob.returnurl />
</cfif>


<!--- force options ... userkey holding users ... --->
<cfset a_struct_force_options_replace = StructNew()>
<cfset a_struct_force_options_replace.userkey = ArrayNew(1)>

<cfset a_struct_force_options_replace.userkey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.userkey, application.components.cmp_user.GetFullNameByentrykey(request.stSecurityContext.myuserkey), request.stSecurityContext.myuserkey)>

<cfoutput query="q_select_assignments">
	<cfset a_struct_force_options_replace.userkey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.userkey, application.components.cmp_user.GetUsernamebyentrykey(q_select_assignments.userkey), q_select_assignments.userkey)>
</cfoutput>

<cfset a_str_displayed_userkeys = ''>
<cfoutput query="q_select_shares">

	<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupMembers" returnvariable=q_select_workgroup_members>
		<cfinvokeargument name="workgroupkey" value="#q_select_shares.workgroupkey#">
	</cfinvoke>							
	
	
	
	<cfloop query="q_select_workgroup_members">
	
		<cfif ListFind(a_str_displayed_userkeys, q_select_workgroup_members.userkey) IS 0>
		
			<cfset a_str_displayed_userkeys = ListAppend(a_str_displayed_userkeys, q_select_workgroup_members.userkey)>		
			<cfset a_struct_force_options_replace.userkey = application.components.cmp_forms.AddItemToArrayOfOptions(a_struct_force_options_replace.userkey, application.components.cmp_user.GetUsernamebyentrykey(q_select_workgroup_members.userkey), q_select_workgroup_members.userkey)>
		</cfif>
	</cfloop>

</cfoutput>		
	
<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(force_element_values = a_struct_force_element_values,
						action = a_str_operation,
						query = CreateEditFollowupJob.query,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '367EDCE2-01C6-59CB-46081CFA4FDD9927',
						force_options_replace = a_struct_force_options_replace) />

<cfoutput>#a_str_form#</cfoutput>

