<!--- //

	Module:		Addressbook
	Action:		ShowContacts
	Description:Display all contacts

				Show top header with filters, search and so on ...

// --->

<cfset a_int_clear_all_stored_criteria_for_simple_filter = GetUserPrefPerson('addressbook', 'clearcriteria.unstoredfilter', '1', '', false) />
<cfset a_str_js = '' />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="viewkey" value="#url.filterviewkey#">
	<cfinvokeargument name="mergecriterias" value="true">
	<cfinvokeargument name="itemttype" value="#a_str_display_data_type#">
</cfinvoke>

<ul class="nav nav-tabs" role="tablist" id="myTab">
  <li class="active"><a href="#basicFilter" role="tab" data-toggle="tab" data-type="static"><cfoutput>#( GetLangVal('adrb_wd_the_view') & '/' & GetLangVal('adrb_wd_quicksearch') )#</cfoutput></a></li>
  <li><a href="#advancedSearch" data-toggle="tab" data-type="redirect" data-url="index.cfm?action=AdvancedSearch&amp;filterdatatype=0"><cfoutput>#GetLangVal('adrb_ph_advanced_search')#</cfoutput></a></li>
  <li><a href="#storedFilters" role="tab" data-toggle="tab" data-type="remote" data-url="index.cfm?Action=ShowTopPanelSavedFilterList&filterdatatype=<cfoutput>#Val(url.filterdatatype)#</cfoutput>"><cfoutput>#( GetLangVal('crm_ph_saved_filters') & ' (' & q_select_all_filters.recordcount & ')' )#</cfoutput></a></li>
</ul>

<!-- Tab panes -->
<div class="tab-content" style="border-left: silver solid 1px;border-bottom:silver solid 1px;border-right: silver solid 1px">
	<div class="tab-pane" id="storedFilters">

	</div>
	<div class="tab-pane active" id="basicFilter">


			<table border="0" cellpadding="6" cellspacing="0" class="table table_details">
				<tr>
					<td>

							<b><span class="glyphicon glyphicon-eye-open"></span> <cfoutput>#GetLangVal('adrb_wd_view')#</cfoutput></b>

							<table class="table">
								<tr>
									<td>
										<a <cfif sOrderBy IS ''></cfif> href="index.cfm?&orderby=company%2Csurname&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
									</td>
									<td>
										<a <cfif sOrderBy IS 'lastdisplayed'>style="font-weight:bold;"</cfif> href="index.cfm?&orderby=lastdisplayed&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_last_displayed')#</cfoutput></a>
									</td>
								</tr>
								<tr>
									<td>
										<a <cfif sOrderBy IS 'latelyadded'>style="font-weight:bold;"</cfif> href="index.cfm?&orderby=latelyadded&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_last_added')#</cfoutput></a>
									</td>
									<td>
										<a <cfif sOrderBy IS 'ownitems'>style="font-weight:bold;"</cfif> href="index.cfm?&orderby=ownitems&filterdatatype=<cfoutput>#url.filterdatatype#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_my_items')#</cfoutput></a>
									</td>
								</tr>
							</table>

					</td>
					<td>

						 	<b><span class="glyphicon glyphicon-search"></span> <cfoutput>#GetLangVal('cm_wd_search')#</cfoutput></b>

						 	<form id="idformtopsearch" name="idformtopsearch" method="POST" onSubmit="ShowLoadingStatus();" action="index.cfm?action=DoAddFilterSearchCriteria" style="margin:0px;">
							<input type="hidden" name="frmfilterviewkey" value="<cfoutput>#url.filterviewkey#</cfoutput>" />
							<input type="hidden" name="frmdisplaydatatype" value="<cfoutput>#a_str_display_data_type#</cfoutput>" />
							<input type="hidden" name="frmarea" value="contact" />

							<table class="table table_details">

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
										<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn btn-success" />
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
										<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn" />
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
										<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>" class="btn" />
									</td>
								</tr>

								</cfcase>
							</cfswitch>
							</table>
							</form>


					</td>
					<td>

						<b><span class="glyphicon glyphicon-folder-open"></span> <cfoutput>#GetLangVal('adrb_wd_filter')#</cfoutput></b>

						<cfoutput>
						<table class="table table_details">
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

						<b>Spezial-Ansichten</b>
						<br />
						<a href="index.cfm?action=telephonelist"><cfoutput>#GetLangVal('adb_wd_telephonelist')#</cfoutput></a>
|
						<a href="index.cfm?action=birthdaylist"><cfoutput>#GetLangVal('adrb_wd_birthdaylist')#</cfoutput></a>


					</td>
					<td valign="top" class="" id="idtdfilterselect"></td>
				</tr>
			</table>


	</div>
	<div class="tab-pane" id="storedFilters">


	</div>
</div>

<script>
$('#myTab a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');

	switch ($(this).attr('data-type')) {

		case "remote": {

				var u =  $(this).data('url');

				$.get( u, function( data ) {
				  $( "#storedFilters" ).html( data );

				});

				break;
		}

		case "redirect": {
				location.href = $(this).data('url');
				break;
		}

	}

})
</script>



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

							<a href="index.cfm?action=AdvancedSearch&entrykey=#url.filterviewkey#">#GetLangVal('crm_ph_edit_filter_criteria')#</a>


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


						<!--- 	<form name="formtopcrmsearch" id="formtopcrmsearch" action="index.cfm" method="get" style="margin:0px; ">
							<b><cfoutput>#GetLangVal('cm_wd_search')#</cfoutput></b>
							<br /><br />
							<input type="text" name="search" style="width:100px; " size="10">&nbsp;
							</form> --->

						</td>
--->




<cfset ShowViewFilterCriteriaRequest = StructNew() />
<cfset ShowViewFilterCriteriaRequest.Viewkey = url.filterviewkey />

<cfif ArrayLen(a_struct_crm_filter.criterias) GT 0>

	<div class="bb bl br mischeader" style="padding:6px;display:none;padding-top:8px;" id="iddiv_current_filter_criteria">

					<span class="glyphicon glyphicon-search"></span> <cfoutput>#GetLangVal('crm_ph_active_filter_criteria')# (#ArrayLen(a_struct_crm_filter.criterias)#)</cfoutput>

					<cfif Len(url.filterviewkey)>

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


					<cfinclude template="../filter/dsp_inc_show_view_filter_criteria.cfm">

	</div>

	<cfsavecontent variable="a_str_js">
		$(document).ready(function() { $('#iddiv_current_filter_criteria').fadeIn('slow'); });
		function doAddCRMSearchParameter(filterviewkey,property,value) {

			}
	</cfsavecontent>

	<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
</cfif>

<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
