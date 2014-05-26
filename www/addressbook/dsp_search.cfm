<!--- //

	Module:		AddressBook
	Action:		AdvancedSearch
	Description:advanced address book search
	

// --->
	
<!--- // entrykey of search/view // --->
<cfparam name="url.entrykey" type="string" default="">
<!--- type of item ... --->
<cfparam name="url.filterdatatype" type="numeric" default="0">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_ph_advanced_search')) />

<!--- load all criterias of the current searchkey --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetViewFilters" returnvariable="q_select_filter">
	<cfinvokeargument name="viewkey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<!--- load all filters ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>		


<cfif (q_select_all_filters.recordcount GT 0) AND Len(url.entrykey) IS 0>

<cfsavecontent variable="a_str_content">
		
	<div style="padding:6px; ">
	<cfoutput>#GetLangVal('crm_ph_filter_click_to_load')#</cfoutput>
	</div>

	<table class="table_overview">
	  <tr class="tbl_overview_header">
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_created')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
		</td>
	  </tr>
	  <cfoutput query="q_select_all_filters">
	  <tr>
		<td>
			<a style="font-weight:bold;" href="index.cfm?action=Advancedsearch&entrykey=#q_select_all_filters.entrykey#"><img src="/images/si/find.png" class="si_img" /> #htmleditformat(q_select_all_filters.viewname)#</a>
		</td>
		<td>
			#htmleditformat(q_select_all_filters.description)#
		</td>
		<td>
			#DateFormat(q_select_all_filters.dt_created, request.stUserSettings.default_dateformat)#
		</td>
		<td>
			<a onClick="ShowSimpleConfirmationDialog('index.cfm?action=DeleteCRMFilter&entrykey=#q_select_all_filters.entrykey#');" href="##"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('cm_wd_delete')#</a>
		</td>
	  </tr>
	  </cfoutput>
	</table>


</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_saved_filters') & ' (' & q_select_all_filters.recordcount & ')', '', a_str_content)#</cfoutput>

</cfif>


<cfif (q_select_filter.recordcount GT 0) AND (Len(url.entrykey) IS 0)>
	<!--- if empty viewkey and criterias, offer option to save this data ... --->
	
	<cfsavecontent variable="a_str_content">
	
		<div style="padding:6px; ">
			<cfoutput>#GetLangVal('crm_ph_save_filter_criterias_description')#</cfoutput>
		</div>
		
		<form action="index.cfm?action=SaveCRMFilter" method="post" style="margin:0px; ">
		<table class="table_details table_edit_form">
		  <tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmname" size="40">
			</td>
		 </tr>
		 <tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmdescription" size="40">
			</td>
		</tr>
		<tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" class="btn" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
			</td>
		  </tr>
		</table>
		</form>
	
		<br/>
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_save_filter_criterias'), '', a_str_content)#</cfoutput>

	
</cfif>

<cfif q_select_filter.recordcount GT 0>
<cfsavecontent variable="a_str_content">

	<table class="table_details">
	  <tr>
		<td>
	
		<cfif Len(url.entrykey) GT 0>
		
			<cfquery name="q_select_current_filter" dbtype="query">
			SELECT
				*
			FROM
				q_select_all_filters
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
			;
			</cfquery>
			
			<cfoutput>
			<b>#GetLangVal('cm_wd_name')#: #htmleditformat(q_select_current_filter.viewname)#</b>
			<br /> 
			#GetLangVal('cm_wd_description')#: #htmleditformat(q_select_current_filter.description)#
			<br /> 
			#GetLangVal('cm_wd_created')#: #DateFormat(q_select_current_filter.dt_created, request.stUserSettings.default_Dateformat)#
			</cfoutput>
			<br /><br />  
		</cfif>
		
		<cfoutput>#GetLangVal('crm_ph_filter_current_criterias')#</cfoutput>

		<cfset ShowViewFilterCriteriaRequest.Viewkey = url.entrykey>
		<cfinclude template="filter/dsp_inc_show_view_filter_criteria.cfm">

		</td>
		<td>
			
		</td>
	  </tr>
	</table>
	<br/>
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<cfoutput>
	<input type="button" onclick="GotoLocHref('index.cfm?action=ShowContacts&filterdatatype=#url.filterdatatype#&filterviewkey=#url.entrykey#');" class="btn" value="#GetLangVal('crm_ph_apply_filter_view_now')#" />
	<!--- <input type="button" class="btn" onclick="GotoLocHref('index.cfm?action=AdvancedSearch');" value="#GetLangVal('crm_ph_create_new_empty_filter')#" />
	 ---></cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_current_filter_criteria') & ' (' & q_select_filter.recordcount & ')', a_str_btn, a_str_content)#</cfoutput>
</cfif>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<!--- search ... --->
<cfsavecontent variable="a_str_content">
	<cfinclude template="filter/dsp_inc_advanced_search_criteria_table.cfm">
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<input type="submit" class="btn" value="<cfoutput>#GetLangVal('crm_ph_button_add_filter_criteria')#</cfoutput>" />
</cfsavecontent>

<form action="index.cfm?action=AddCRMFilterCriteria" method="post" style="margin:0px; ">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>" />
<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_add_criteria'), a_str_btn, a_str_content)#</cfoutput>
</form>
