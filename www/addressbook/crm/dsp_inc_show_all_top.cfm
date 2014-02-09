<!--- //

	Module:		Addressbook
	Action:		ShowContacts
	Description:Display all contacts
	
				Show top header with filters, search and so on ...
	
// --->

<cfset a_int_clear_all_stored_criteria_for_simple_filter = GetUserPrefPerson('addressbook', 'clearcriteria.unstoredfilter', '1', '', false) />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>		

<cfset tmp = StartNewTabNavigation() />
<cfset tmp = AddTabNavigationItem(GetLangVal('adrb_wd_the_view') & '/' & GetLangVal('adrb_wd_quicksearch'), 'javascript:ShowTopCRMPanel(''simple'');', '') /> 

<!--- for crm customers, display filters plus advanced search ... --->
<cfset tmp = AddTabNavigationItem(GetLangVal('adrb_ph_advanced_search'), 'javascript:ShowTopCRMPanel(''advanced'', #url.filterdatatype#);', '') /> 

<cfif q_select_all_filters.recordcount GT 0>
	<cfset tmp = AddTabNavigationItem(GetLangVal('crm_ph_saved_filters') & ' (' & q_select_all_filters.recordcount & ')', 'javascript:ShowTopCRMPanel(''savedfilters'', #url.filterdatatype#);', '')> 
</cfif>

<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="viewkey" value="#url.filterviewkey#">
	<cfinvokeargument name="mergecriterias" value="true">
	<cfinvokeargument name="itemttype" value="#a_str_display_data_type#">
</cfinvoke>

<cfoutput>#BuildTabNavigation('id_div_search_panel_content', false)#</cfoutput><div id="id_div_search_panel_simple" style="display:none;padding:10px;">
	
	<table border="0" cellpadding="6" cellspacing="0">
		<tr>
			<td class="br" valign="top">
			
					<b><img src="/images/si/eye.png" class="si_img" /> <cfoutput>#GetLangVal('adrb_wd_view')#</cfoutput></b>
					
					<table cellpadding="4" cellspacing="0" border="0">
						<tr>
							<td>
								<a <cfif sOrderBy IS ''></cfif> href="default.cfm?&orderby=company%2Csurname&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
							</td>
							<td>
								<a <cfif sOrderBy IS 'lastdisplayed'>style="font-weight:bold;"</cfif> href="default.cfm?&orderby=lastdisplayed&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_last_displayed')#</cfoutput></a>
							</td>
						</tr>
						<tr>
							<td>
								<a <cfif sOrderBy IS 'latelyadded'>style="font-weight:bold;"</cfif> href="default.cfm?&orderby=latelyadded&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_last_added')#</cfoutput></a>
							</td>
							<td>
								<a <cfif sOrderBy IS 'ownitems'>style="font-weight:bold;"</cfif> href="default.cfm?&orderby=ownitems&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_my_items')#</cfoutput></a>
							</td>
						</tr>
					</table>
					
			</td>
			<td class="br" valign="top">
				
				 	<b><img src="/images/si/find.png" class="si_img" /><cfoutput>#GetLangVal('cm_wd_search')#</cfoutput></b>
				 	
				 	<form id="idformtopsearch" name="idformtopsearch" method="POST" onSubmit="ShowLoadingStatus();" action="default.cfm?action=DoAddFilterSearchCriteria" style="margin:0px;">
					<input type="hidden" name="frmfilterviewkey" value="<cfoutput>#url.filterviewkey#</cfoutput>" />
					<input type="hidden" name="frmdisplaydatatype" value="<cfoutput>#a_str_display_data_type#</cfoutput>" />
					<input type="hidden" name="frmarea" value="contact" />
					
					<table cellpadding="4" cellspacing="0" border="0">
						
					<cfswitch expression="#a_str_display_data_type#">
						<cfcase value="0,3" delimiters=",">
						<input type="hidden" name="frm_fields" value="surname,firstname,company,email_prim,b_city,b_zipcode" />
						<tr>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmfirstname" value="" size="10" />
								<input type="hidden" name="frmfirstname_displayname" value="<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>" />
							</td>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>
								</td>
							<td>
								<input type="text" name="frmsurname" value="" size="10" />
								<input type="hidden" name="frmsurname_displayname" value="<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>" />
							</td>
							<td>
								<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn2" />
							</td>
						</tr>
						<tr>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmcompany" value="" size="10" />
								<input type="hidden" name="frmcompany_displayname" value="<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>" />
							</td>
							<td>
								<cfoutput>#GetLangVal('cm_wd_email')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmemail_prim" value="" size="10" />
								<input type="hidden" name="frmemail_prim_displayname" value="<cfoutput>#GetLangVal('cm_wd_email')#</cfoutput>" />
							</td>
							<td>
								<cfif Len(url.filterviewkey) IS 0>
									<input type="checkbox" value="1" name="frmclearallstoredcriteria" <cfoutput>#WriteCheckedElement(a_int_clear_all_stored_criteria_for_simple_filter, 1)#</cfoutput> /> <cfoutput>#GetLangVal('adrb_ph_start_new_search')#</cfoutput>
								</cfif>
							</td>
						</tr>
						<tr>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmb_city" value="" size="10" />
								<input type="hidden" name="frmb_city_displayname" value="<cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>" />
							</td>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>								
							</td>
							<td>
								<input type="text" name="frmb_zipcode" value="" size="10" />
								<input type="hidden" name="frmb_zipcode_displayname" value="<cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>" />
							</td>
						</tr>
						</cfcase>
						<cfcase value="2">
						<!--- leads --->
						<input type="hidden" name="frm_fields" value="surname,company,leadsource" />
						<tr>
							<td>
								<cfoutput>#GetLangVal('crm_ph_lead_source')#</cfoutput>
							</td>
							<td>
								<select name="frmleadsource">
								<cfoutput>
								<cfloop from="0" to="8" index="ii">
									<option value="#ii#">#htmleditformat(GetLangVal('crm_ph_leadsource_' & ii))#</option>
								</cfloop>
								</cfoutput>
								<input type="hidden" name="frmfirstname_displayname" value="<cfoutput>#GetLangVal('crm_ph_lead_source')#</cfoutput>" />
							</td>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>
								</td>
							<td>
								<input type="text" name="frmsurname" value="" size="10" />
								<input type="hidden" name="frmsurname_displayname" value="<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>" />
							</td>
						</tr>
						<tr>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmcompany" value="" size="10" />
								<input type="hidden" name="frmcompany_displayname" value="<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>" />
							</td>
							<td>
							</td>
							<td>
								<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn2" />
							</td>
						</tr>
						</cfcase>
						<cfcase value="1">
						<input type="hidden" name="frm_fields" value="company" />
						<!--- accounts ... --->
						<tr>
							<td>
								<cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput>
							</td>
							<td>
								<input type="text" name="frmcompany" value="" size="10" />
								<input type="hidden" name="frmcompany_displayname" value="<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>" />
							</td>
							<td>
							</td>
							<td>
								<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn2" />
							</td>
						</tr>
						
						</cfcase>
					</cfswitch>
					</table>
					</form>
						
				
			</td>	
			<td valign="top">
				
				<b><img src="/images/si/database_add.png" class="si_img" /><cfoutput>#GetLangVal('adrb_wd_filter')#</cfoutput></b>
				
				<cfoutput>
				<table cellpadding="4" cellspacing="0" border="0">
					<tr>
						<td>
							<a href="##" onclick="ShowFilterAreaData('#url.filterviewkey#', '2', 'category', '#a_str_display_data_type#');">#GetLangVal('cm_wd_category')#</a>
						</td>
						<td>
							<a href="##" onclick="ShowFilterAreaData('#url.filterviewkey#', '0', 'workgroup', '#a_str_display_data_type#');">#GetLangVal('cm_wd_workgroup')#</a>
						</td>
					</tr>
					<tr>
						<td>
							<a href="##" onclick="ShowFilterAreaData('#url.filterviewkey#', '0', 'custodian', '#a_str_display_data_type#');">#GetLangVal('crm_wd_custodian')#</a>
						</td>		
						<td>
							<a href="##" onclick="ShowFilterAreaData('#url.filterviewkey#', '2', 'criteria', '#a_str_display_data_type#');">#GetLangVal('crm_wd_criteria')#</a>
						</td>
					</tr>
				</table>
				</cfoutput>

			</td>
			<td valign="top" class="bl" id="idtdfilterselect"></td>	
		</tr>
	</table>
	
	<!--- 
	
		<table border="0" cellspacing="0" cellpadding="6">
			  <tr>
			  <cfif ArrayLen(a_struct_crm_filter.criterias) GT 0>
			  	<td nowrap valign="top" class="br">
					
					<cfif Len(url.filterviewkey) GT 0>
						<cfinvoke component="#a_cmp_crm_sales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
							<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
							<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
						</cfinvoke>		
						
						<cfquery name="q_select_current_filter" dbtype="query">
						SELECT
							*
						FROM
							q_select_all_filters
						WHERE
							entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.filterviewkey#">
						;
						</cfquery>			
		


						<cfoutput query="q_select_current_filter">
						
							<div style="line-height:18px;">
							
								<b>#GetLangVal('crm_ph_filter_active')#: "#htmleditformat(q_select_current_filter.viewname)#"</b>
								<cfif Len(q_select_current_filter.description) GT 0>
								<br />
								#htmleditformat(q_select_current_filter.description)#
								</cfif>								
								<br />
								
							<a href="default.cfm?action=AdvancedSearch&entrykey=#url.filterviewkey#">#GetLangVal('crm_ph_edit_filter_criteria')#</a>
							
							
							</div>
						
						</cfoutput>
						<br />
					<cfelse>
						<b><cfoutput>#GetLangVal('crm_ph_active_filter_criteria')#</cfoutput></b>
					<br /><br />
					</cfif>	
					
					<!--- if not saved, allow to delete criteria --->
					<cfif Len(url.filterviewkey) GT 0>
						<cfset ShowViewFilterCriteriaRequest.AllowDeleteCriteria = false>				
					<cfelse>
						<cfset ShowViewFilterCriteriaRequest.AllowDeleteCriteria = true>
					</cfif>
					<cfset ShowViewFilterCriteriaRequest.Viewkey = url.filterviewkey>
					<cfinclude template="dsp_inc_show_view_filter_criteria.cfm">
					
				</td>
			  </cfif>
					  	<td nowrap valign="top" class="br">
						 
						  	
						<!--- 	<form name="formtopcrmsearch" id="formtopcrmsearch" action="default.cfm" method="get" style="margin:0px; ">
							<b><cfoutput>#GetLangVal('cm_wd_search')#</cfoutput></b>
							<br /><br />
							<input type="text" name="search" style="width:100px; " size="10">&nbsp;
							</form> --->
							
						</td>
--->
		
</div>


<cfset ShowViewFilterCriteriaRequest = StructNew() />
<cfset ShowViewFilterCriteriaRequest.Viewkey = url.filterviewkey />

<cfif ArrayLen(a_struct_crm_filter.criterias) GT 0>
	
	<div class="bb bl br mischeader" style="padding:0px;display:none;padding-top:8px;" id="iddiv_current_filter_criteria">
		
		<table border="0" style="padding:4px;padding-left:10px;width:100%;">
			<tr>
				<td style="width:170px;font-weight:bold;" nowrap>
					<img src="/images/si/find.png" class="si_img" /> <cfoutput>#GetLangVal('crm_ph_active_filter_criteria')# (#ArrayLen(a_struct_crm_filter.criterias)#)</cfoutput>
					
					<cfif Len(url.filterviewkey) GT 0>
						
						<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
							<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
							<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
						</cfinvoke>	
						
						<cfquery name="q_select_filter_name" dbtype="query">
						SELECT
							*
						FROM
							q_select_all_filters
						WHERE
							entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.filterviewkey#">
						</cfquery>
						
						<br /> 
						<img src="/images/space_1_1.gif" class="si_img" alt="" /> <cfoutput>#GetLangVal('crm_ph_filter_active')#: #htmleditformat(q_select_filter_name.viewname)#</cfoutput>
						
					</cfif>
				
				</td>
				<td style="width:100%" valign="top">
					<cfinclude template="../filter/dsp_inc_show_view_filter_criteria.cfm">
				</td>
			</tr>
		</table>
	</div>
	
	<cfsavecontent variable="a_str_js">
		$(document).ready(function() { $('#iddiv_current_filter_criteria').fadeIn('slow'); });
		function doAddCRMSearchParameter(filterviewkey,property,value) {
			
			}
	</cfsavecontent>
	
	<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />
</cfif>

<cfsavecontent variable="a_str_js">
	$(document).ready(function() { ShowTopCRMPanel('simple'); });
</cfsavecontent>

<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
