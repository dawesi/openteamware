<!--- //

	Module:		Address Book
	Action:		ShowMassActions
	Description:Display possible mass actions


// --->

<cfparam name="url.datatype" type="numeric" default="0">

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = session.a_struct_temp_data.addressbook_selected_entrykeys />

<cfset stOpts = StructNew() />
<cfset stOpts.maxrows = 99999 />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="filterdatatypes" value="#url.datatype#">
	<cfinvokeargument name="loadoptions" value="#stOpts#" />
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />


<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('cm_wd_contacts'))#</cfoutput>

<div style="height:150px;overflow:auto;" class="b_all">
<ol>
<cfoutput query="q_select_contacts">

	<cfquery name="q_select_contact" dbtype="query">
	SELECT
		*
	FROM
		q_select_contacts
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_contacts.entrykey#">
	;
	</cfquery>

	<li>#si_img('bullet_orange')# #application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_contacts.entrykey, query_holding_data = q_select_contact)#</li>
</cfoutput>
</ol>
</div>
<br />
<cfoutput>#WriteSimpleHeaderDiv(MakeFirstCharUCase(GetLangVal('cm_ph_edit_together')))#</cfoutput>

<!--- ... set mass criteria ... --->
<cfset a_str_form_id = 'form' & CreateUUIDJS() />

<cfset application.components.cmp_forms.StartNewForm(action = 'index.cfm?action=DoExecuteMassActions&type=any',
				action_type = 'create',
				method = 'POST',
				onSubmit = 'DisplayPleaseWaitMsgOnLocChange()',
				form_id = a_str_form_id) />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'hidden',
				input_name = 'frmentrykeys',
				input_value = session.a_struct_temp_data.addressbook_selected_entrykeys) />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'hidden',
				input_name = 'frmdatatype',
				input_value = url.datatype) />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'boolean',
				field_name = GetLangVal('crm_ph_replace_existing_assignments'),
				input_name = 'frmreplaceexistingassignments') />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'selector',
				field_name = GetLangVal('crm_wd_criteria'),
				input_name = 'frmcriteria',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'criteria') />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'selector',
				field_name = GetLangVal('cm_wd_categories'),
				input_name = 'frmcategories',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'categories') />

<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'selector',
				field_name = GetLangVal('crm_wd_filter_element_assignedto'),
				input_name = 'frmassignedusers',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'assignedusers') />


<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'selector',
				field_name = GetLangVal('cm_wd_workgroups'),
				input_name = 'frmworkgroupshares',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'workgroupshares') />


<cfset application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'submit',
				field_name = MakeFirstCharUCase(GetLangVal('cm_ph_edit_together')),
				input_name = 'frmsubmit',
				input_value = session.a_struct_temp_data.addressbook_selected_entrykeys) />

<cfoutput>
#application.components.cmp_forms.WriteFormStart()#
#application.components.cmp_forms.WriteFormElements()#
#application.components.cmp_forms.WriteFormEnd()#
</cfoutput>


