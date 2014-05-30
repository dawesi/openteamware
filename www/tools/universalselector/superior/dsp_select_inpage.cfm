<!--- //

	Module:		UniversalSelector
	Description:Select superior contact
	
	Header:		

// --->

<!--- the entrykey of the parent contact ... --->
<cfparam name="form.frmcompany" type="string" default="">

<cfif Len(form.frmcompany) IS 0>

	<cfoutput>#GetLangVal('adrb_ph_have_to_set_account_first')#</cfoutput>
	
	<cfexit method="exittemplate">
</cfif>

<cfset stCRMFilter = StructNew() />
<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 0,
									internalfieldname = 'parentcontactkey',
									comparevalue = form.frmcompany) />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_select_other_users">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
	<cfinvokeargument name="CacheLookupData" value="false">
</cfinvoke> 

<cfset q_select_hits = stReturn_select_other_users.q_select_contacts />

<cfquery name="q_select_hits" dbtype="query">
SELECT
	*
FROM
	q_select_hits
WHERE
	NOT entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.objectkey#">
;
</cfquery>

<cfif q_select_hits.recordcount IS 0>
	<cfoutput>#GetLangVal('adrb_ph_set_superior_no_other_contacts_found')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>
	
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('adrb_wd_department')# / #GetLangVal('adrb_wd_position')# </cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
		</td>
	</tr>
	<cfoutput query="q_select_hits">
	
	<cfset a_str_display_name = application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_hits.entrykey) />
		
	<tr>
		<td>
			#htmleditformat(a_str_display_name)#
		</td>
		<td>
			#htmleditformat(q_select_hits.department)# #htmleditformat(q_select_hits.aposition)#
		</td>
		<td>
			<input onclick="UniversalSelectorSetReturnValues('#q_select_hits.entrykey#', '#jsstringformat(a_str_display_name)#');" type="button" value="#GetLangval('cm_ph_btn_action_apply')#" class="btn" />
		</td>
	</tr>
	</cfoutput>
</table>

