<!--- //

	Module:		Address Book
	Description:Display filter criteria
	

// --->

<cfparam name="ShowViewFilterCriteriaRequest.Viewkey" type="string" default="">
<cfparam name="ShowViewFilterCriteriaRequest.AllowDeleteCriteria" type="boolean" default="true">

<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="viewkey" value="#ShowViewFilterCriteriaRequest.Viewkey#">
	<cfinvokeargument name="mergecriterias" value="true">
</cfinvoke>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetFullCriteriaQuery" returnvariable="q_select_all_criteria">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<!--- TODO: translate german strings --->
<cfif ArrayLen(a_struct_crm_filter.criterias) GT 0>

<table class="table table-hover">
<cfloop from="1" to="#ArrayLen(a_struct_crm_filter.criterias)#" index="ii">
<cfoutput>

<td style="padding-left:12px;">
	
	<img src="/images/si/bullet_orange.png" class="si_img" />
	<cfif ii GT 1>
		<cfswitch expression="#a_struct_crm_filter.criterias[ii].connector#">
			<cfcase value="0">
				#GetLangVal('cm_wd_and')#
			</cfcase>
			<cfcase value="1">
				#GetLangVal('cm_wd_or')#
			</cfcase>
			<cfcase value="2">
				#GetLangVal('cm_ph_and_not')#
			</cfcase>
		</cfswitch>
	</cfif>
	
	<cfswitch expression="#a_struct_crm_filter.criterias[ii].area#">
		<cfcase value="metadata">
			<cfset a_str_name = GetLangVal('crm_wd_filter_element_' & a_struct_crm_filter.criterias[ii].internalfieldname) />
			
			[<b>#htmleditformat(a_str_name)#</b>]
			
			<cfswitch expression="#a_struct_crm_filter.criterias[ii].internalfieldname#">
				<cfcase value="followup">
					<cfswitch expression="#a_struct_crm_filter.criterias[ii].operator#">
						<cfcase value="0">gesetzt</cfcase>
						<cfcase value="1">gesetzt und ueberfaellig</cfcase>
					</cfswitch>
				</cfcase>
				
				<cfcase value="custodian">
					#GetLangVal('crm_wd_filter_operator_'&a_struct_crm_filter.criterias[ii].operator)#
					[<b>#htmleditformat(application.components.cmp_user.GetFullNameByentrykey(entrykey = a_struct_crm_filter.criterias[ii].comparevalue))#</b>]
				</cfcase>
				
				<cfcase value="workgroup">
					#GetLangVal('crm_wd_filter_operator_'&a_struct_crm_filter.criterias[ii].operator)#
					#application.components.cmp_workgroups.GetWorkgroupNameByEntryKey(a_struct_crm_filter.criterias[ii].comparevalue)#
				</cfcase>
				
				<cfcase value="criteria">

					#GetLangVal('crm_wd_filter_operator_' & a_struct_crm_filter.criterias[ii].operator)#
					
					<!--- add a dummy value ... --->
					<cfset a_str_compare_id_value = ListAppend(a_struct_crm_filter.criterias[ii].comparevalue, '-999') />
					
					<cfquery name="q_select_criteria_name" dbtype="query">
					SELECT
						*
					FROM
						q_select_all_criteria
					WHERE
						id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_str_compare_id_value#" list="yes">)
					;
					</cfquery>
					
					<cfloop query="q_select_criteria_name">
						[<b>#htmleditformat(q_select_criteria_name.criterianame)#</b>]&nbsp;
					</cfloop>
				</cfcase>
			</cfswitch>
			
			
			
			
		</cfcase>
		<cfcase value="crm">
			<i>#a_struct_crm_filter.criterias[ii].displayname#</i>
			
			#GetLangVal('crm_wd_filter_operator_'&a_struct_crm_filter.criterias[ii].operator)#
			
			#htmleditformat(a_struct_crm_filter.criterias[ii].comparevalue)#
		</cfcase>
		<cfcase value="contact">
			[<b>#a_struct_crm_filter.criterias[ii].displayname#</b>] 
			
			#GetLangVal('crm_wd_filter_operator_' & a_struct_crm_filter.criterias[ii].operator)#
			
			<!--- switch about what to display ... --->
			<cfswitch expression="#a_struct_crm_filter.criterias[ii].internalfieldname#">
				<cfcase value="criteria">
					
					<cfquery name="q_select_criteria_name" dbtype="query">
					SELECT
						*
					FROM
						q_select_all_criteria
					WHERE
						id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#a_struct_crm_filter.criterias[ii].comparevalue#" list="yes">)
					;
					</cfquery>
					
					<cfloop query="q_select_criteria_name">
						[<b>#htmleditformat(q_select_criteria_name.criterianame)#</b>]&nbsp;
					</cfloop>
					
				</cfcase>
				<cfcase value="nace_code">
					[<b>#htmleditformat(application.components.cmp_addressbook.ReturnIndustryNameByNACECode(nace_code = a_struct_crm_filter.criterias[ii].comparevalue, language = request.stUserSettings.language))#</b>]
				</cfcase>
				<cfdefaultcase>
					[<b>#htmleditformat(a_struct_crm_filter.criterias[ii].comparevalue)#</b>]
				</cfdefaultcase>
			</cfswitch>
			
		</cfcase>
	</cfswitch>
	 
	 
</td>
<cfif ShowViewFilterCriteriaRequest.AllowDeleteCriteria>
	<td>
		<a href="index.cfm?Action=DoDeleteFilterCriteria&entrykey=#a_struct_crm_filter.criterias[ii].entrykey#&viewkey=#a_struct_crm_filter.criterias[ii].viewkey#" class="nl"><img align="absmiddle" src="/images/si/delete.png" alt="#GetLangVal('cm_wd_delete')#" border="0" /></a>
	</td>
</cfif>
</tr>
</cfoutput>
</cfloop>
</table>
</cfif>