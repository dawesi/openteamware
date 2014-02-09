<!--- //

	Module:        Import
	Description:   Show possible fields mappings
	

// --->

<cfparam name="url.jobkey" type="string">
<cfparam name="url.advancedcriteriaselection" type="numeric" default="0">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_ph_edit_assignment')) />

<cfinvoke component="#application.components.cmp_import#" method="GetImportTable" returnvariable="a_struct_fields_source">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="jobkey" value="#url.jobkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_tools#" method="ReturnDatabaseFieldsOfService" returnvariable="q_select_fields">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="servicekey" value="#a_struct_fields_source.servicekey#">
</cfinvoke>

<cfset q_select_criteria = application.components.cmp_crmsales.GetFullCriteriaQuery(companykey = request.stSecurityContext.mycompanykey) />

<cfquery name="q_select_criteria" dbtype="query">
SELECT
	*
FROM
	q_select_criteria
ORDER BY
	parent_id,criterianame
;
</cfquery>

<!--- display mapping editor ... --->
<form action="default.cfm?action=DoCreateMapping" method="post" onsubmit="DisplayPleaseWaitMsgOnLocChange();">
<input type="hidden" name="frm_jobkey" value="<cfoutput>#url.jobkey#</cfoutput>" />
<input type="hidden" name="frmadvancedcriteriaselection" value="<cfoutput>#url.advancedcriteriaselection#</cfoutput>" />
<table class="table_details table_edit_form">
	
	<tr class="mischeader">
		<td class="field_name">
			<cfoutput>#GetLangVal('import_ph_field_in_your_file')#</cfoutput>
		</td>
		<td colspan="2">
			<cfoutput>#GetLangVal('import_ph_example_data')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('import_ph_field_in_database')#</cfoutput>
		</td>
		<td>
		
		</td>
	</tr>
	<!--- show openTeamware.com fields ... and fields of own table ... let the user define which field
		if his own table corresponds with a certain openTeamware.com field --->
	<cfloop list="#a_struct_fields_source.q_select_data.columnlist#" index="a_str_col_name">
		
		<cfif a_str_col_name NEQ 'ibx_entrykey'>
		<tr>
			<td class="field_name">
				<cfoutput>#htmleditformat(a_str_col_name)#</cfoutput>
			</td>
			<td class="addinfotext">
				
				<cftry>
				<cfquery name="q_select_demo_data" dbtype="query" maxrows="3">
				SELECT
					#a_str_col_name# AS demo_data
				FROM
					a_struct_fields_source.q_select_data
				WHERE
					NOT #a_str_col_name# = ''
				;
				</cfquery>
				<cfif q_select_demo_data.recordcount GTE 1>
				<cfoutput>#htmleditformat(Shortenstring(q_select_demo_data['demo_data'][1], 30))#</cfoutput>
				</cfif>
				
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
					<cfoutput>#a_str_col_name#</cfoutput>
				</cfcatch>
				</cftry>
			</td>
			<td class="addinfotext">
				<!--- <cfif q_select_demo_data.recordcount GTE 2>
					<cfoutput>#htmleditformat(Shortenstring(q_select_demo_data['demo_data'][2], 30))#</cfoutput>
				</cfif> --->
			</td>
			<td>
				
				<cfset a_str_default_mapping = GetUserPrefPerson('import_data_field_mappings', 'default_col_' & hash(Ucase(a_str_col_name)), '', '', false) />

				<select name="frm_field_mapping_<cfoutput>#a_str_col_name#</cfoutput>" style="width:400px">
	  				<option value=""><cfoutput>#GetLangVal('cm_wd_ignore')#</cfoutput></option>
					<cfoutput query="q_select_fields">
						<option #WriteSelectedElement(a_str_default_mapping, q_select_fields.name_md5)# value="#htmleditformat(q_select_fields.name_md5)#">#htmleditformat(q_select_fields.displayname)#</option>
					</cfoutput>
					
					<!--- allow to specify an attribut that is set if a value is true --->
					<cfif url.advancedcriteriaselection IS 1>
						<option value="">--- Attribute setzen ---</option>
						<cfoutput query="q_select_criteria">
						<option value="SetCriteriaIfTrue_#q_select_criteria.id#">
							#GetLangVal('import_ph_if_true_set_criteria')#
							
							<!--- display the upper level criteria for a better orientation --->
							<cfif Val(q_select_criteria.parent_id) GT 0>
								
								<cfquery name="q_select_parent_criteria_name" dbtype="query">
								SELECT
									criterianame
								FROM
									q_select_criteria
								WHERE
									id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_criteria.parent_id)#">
								;
								</cfquery>
								
								#htmleditformat(q_select_parent_criteria_name.criterianame)# //
							
							</cfif>
							
							#htmleditformat(q_select_criteria.criterianame)#						
						</option>
						</cfoutput>
					</cfif>
				</select>
				
			</td>
		</tr>
		</cfif>
	</cfloop>
	<tr>
		<td></td>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('cm_ph_please_click_here_to_proceed')#</cfoutput>" class="btn" />
		</td>
	</tr>
</table>
</form>

