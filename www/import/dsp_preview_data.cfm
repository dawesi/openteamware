<!--- //

	Module:        Import
	Description:   Preview the data extracted from source
	

// --->

<script type="text/javascript">
function CheckAllItems() {
   $("input[@name=frm_data_entrykey]").each(function()
   {
    this.checked = true;
   });
  }
</script>

<cfsetting requesttimeout="2000">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.jobkey" type="string">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_Wd_preview')) />
		
<cfinvoke component="#application.components.cmp_import#" method="GetImportTable" returnvariable="a_struct_fields_source">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="jobkey" value="#url.jobkey#">
</cfinvoke>

<cfset q_select_import_data = a_struct_fields_source.q_select_data />
<cfset a_int_current_datatype = a_struct_fields_source.datatype />

<cfinvoke component="#application.components.cmp_import#" method="GetFieldMappings" returnvariable="q_fields_mapping">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="jobkey" value="#url.jobkey#">
	<cfinvokeargument name="servicekey" value="#a_struct_fields_source.servicekey#">
</cfinvoke>

<!--- check if we are in address book service ... --->
<cfset a_bol_is_addressbook_contacts = (a_struct_fields_source.servicekey IS '52227624-9DAA-05E9-0892A27198268072') AND
			((a_int_current_datatype IS 0) OR (a_int_current_datatype IS 2)) />
			
<!--- duplicate check possible? we need firstname + surname for that --->
<cfset a_bol_dup_check_is_possible = false />

<cfif a_bol_is_addressbook_contacts>
	<cfquery name="q_select_firstname_field_exists" dbtype="query">
	SELECT
		importfieldname
	FROM
		q_fields_mapping
	WHERE
		fieldname = 'firstname'
	;
	</cfquery>
	
	<cfset a_str_firstname_importfieldname = q_select_firstname_field_exists.importfieldname />
	
	<cfquery name="q_select_company_field_exists" dbtype="query">
	SELECT
		importfieldname
	FROM
		q_fields_mapping
	WHERE
		fieldname = 'company'
	;
	</cfquery>
	
	<cfset a_str_company_importfieldname = q_select_company_field_exists.importfieldname />
	
	<cfquery name="q_select_surname_field_exists" dbtype="query">
	SELECT
		importfieldname
	FROM
		q_fields_mapping
	WHERE
		fieldname = 'surname'
	;
	</cfquery>
	
	<cfset a_str_surname_importfieldname = q_select_surname_field_exists.importfieldname />
	
	<cfset a_bol_dup_check_is_possible = (q_select_firstname_field_exists.recordcount IS 1) AND (q_select_surname_field_exists.recordcount IS 1) />

</cfif>

<cfset a_str_form_id = 'form' & CreateUUIDJS() />

<cfset tmp = application.components.cmp_forms.StartNewForm(action = 'index.cfm?Action=DoImportData',
				action_type = 'create',
				method = 'POST',
				onSubmit = 'DisplayPleaseWaitMsgOnLocChange()',
				form_id = a_str_form_id,
				write_table = false) />
				
<cfset tmp = application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'hidden',
				input_name = 'frm_jobkey',
				input_value = url.jobkey) />
				
<cfset tmp = application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'selector',
				field_name = GetLangVal('crm_wd_criteria'),
				input_name = 'frm_criteria',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'criteria') />
				
<cfset tmp = application.components.cmp_forms.AddFormElement(securitycontext = request.stSecurityContext,
				usersettings = request.stUserSettings,
				datatype = 'text',
				field_name = GetLangVal('cm_wd_categories'),
				input_name = 'frm_add_categories',
				input_value = 'import_#DateFormat(Now(), 'ddmmyyyy')#',
				useuniversalselectorjsfunction = 1,
				useuniversalselectorjsfunction_type = 'categories') />
				
				
<cfoutput>#application.components.cmp_forms.WriteFormStart()#</cfoutput>

<cfsavecontent variable="a_str_btn">
<input type="submit" value="<cfoutput>#GetLangVal('cm_ph_please_click_here_to_proceed')#</cfoutput>" class="btn btn-primary" />
<input class="btn" type="button" value="<cfoutput>#GetLangVal('crm_ph_edit_assignment')#</cfoutput>" onclick="history.go(-1);" />
</cfsavecontent>

<div style="padding-bottom:6px;">
<cfoutput>#a_str_btn#</cfoutput>
</div>

<cfsavecontent variable="a_str_content">
<table class="table_details table_edit_form">
<cfoutput>
	#application.components.cmp_forms.WriteFormElements()#
</cfoutput>
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_assignments'), '', a_str_content)#</cfoutput>

<cfset q_select_criteria = application.components.cmp_crmsales.GetFullCriteriaQuery(companykey = request.stSecurityContext.mycompanykey) />

<!--- load *all* contacts for duplicate checks ... --->
<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 0 />
<cfset a_struct_loadoptions.fieldstoselect = 'firstname,surname,company,entrykey,title,email_prim' />

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_check_duplicates">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filterdatatypes" value="#a_int_current_datatype#">
	<cfinvokeargument name="CacheLookupData" value="false">
	<cfinvokeargument name="loaddistinctcategories" value="false">
</cfinvoke>

<cfset q_select_all_contacts = stReturn_check_duplicates.q_select_contacts />

<!--- display data now ... --->
<cfsavecontent variable="a_str_content">
<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td align="center" class="addinfotext">#</td>
		<td align="center">
			<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>
			<br />
			<a href="javascript:CheckAllItems();">Select all</a>
		</td>
		<cfif a_bol_is_addressbook_contacts AND a_bol_dup_check_is_possible>
			<td>
				<cfoutput>#GetLangVal('crm_wd_duplicates')#</cfoutput>
			</td>
		</cfif>
		<cfoutput query="q_fields_mapping">
		<td>
			<cfif FindNoCase('SetCriteriaIfTrue_', q_fields_mapping.displayname) IS 1>
				<cfset a_str_tmp_criteria_id = ReplaceNoCase(q_fields_mapping.displayname, 'SetCriteriaIfTrue_', '') />
				
				<cfquery name="q_select_criteria_name" dbtype="query">
				SELECT
					*
				FROM
					q_select_criteria
				WHERE
					id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(a_str_tmp_criteria_id)#">
				;
				</cfquery>
				
				#GetLangVal('crm_wd_criteria')# #htmleditformat(q_select_criteria_name.criterianame)# (0/1)
			<cfelse>
				#htmleditformat(q_fields_mapping.displayname)#
			</cfif>
		</td>	
		</cfoutput>
	</tr>
	<cfloop query="a_struct_fields_source.q_select_data">

		<cfset a_bol_duplicate_found = false />
	
		<!--- perform a duplicate check ... --->
		<cfif a_bol_is_addressbook_contacts AND a_bol_dup_check_is_possible>
				
			<cfquery name="q_select_is_duplicate" dbtype="query" maxrows="3">
			SELECT
				firstname,surname,company,title,entrykey
			FROM
				q_select_all_contacts
			WHERE
				UPPER(firstname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_import_data[a_str_firstname_importfieldname][a_struct_fields_source.q_select_data.currentrow])#">
				AND
				UPPER(surname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_import_data[a_str_surname_importfieldname][a_struct_fields_source.q_select_data.currentrow])#">
			;
			</cfquery>
			
			<cfset a_bol_duplicate_found = (q_select_is_duplicate.recordcount GT 0) />

		</cfif>
		<tr>
			<td class="addinfotext" align="center">
				#<cfoutput>#a_struct_fields_source.q_select_data.currentrow#</cfoutput>
			</td>
			<td align="center">
				
				<input type="checkbox" name="frm_data_entrykey" value="<cfoutput>#a_struct_fields_source.q_select_data.ibx_entrykey#</cfoutput>" <cfif NOT a_bol_duplicate_found>checked="yes"</cfif> />

				<!--- <cfif a_bol_is_addressbook_contacts AND a_bol_dup_check_is_possible AND a_bol_duplicate_found>
					<img src="/images/si/exclamation.png" class="si_img" />
				<cfelse>
					<img src="/images/si/add.png" class="si_img" />
				</cfif> --->
				
				
			</td>	
			<cfif a_bol_is_addressbook_contacts AND a_bol_dup_check_is_possible>
			
				<td>
				<cfif a_bol_duplicate_found>
					
					<img src="/images/si/exclamation.png" class="si_img" />
					
					<!--- display possible duplicates ... --->					
					<cfoutput query="q_select_is_duplicate">
					<a href="/addressbook/?action=ShowItem&entrykey=#q_select_is_duplicate.entrykey#" target="_blank">#application.components.cmp_addressbook.GetContactDisplayNameData(query_holding_data = q_select_is_duplicate, entrykey = q_select_is_duplicate.entrykey)#</a>
					<br /> 
					</cfoutput>
				</cfif>
				</td>
			</cfif>		
			<cfloop query="q_fields_mapping">
			<td>
				<cfif ListFindNoCase(q_select_import_data.columnlist, q_fields_mapping.importfieldname) GT 0>
					<cfoutput>#htmleditformat(q_select_import_data[q_fields_mapping.importfieldname][a_struct_fields_source.q_select_data.currentrow])#</cfoutput>
				</cfif>
			</td>	
			</cfloop>
		</tr>
	</cfloop>
</table>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_data') & ' (' & a_struct_fields_source.q_select_data.recordcount & ')', '', a_str_content)#</cfoutput>

<!--- write form end tag ... --->
<cfoutput>#application.components.cmp_forms.WriteFormEnd()#</cfoutput>


