<!--- //

	Module:		CRMSales Report Generation
	Description: 
	

// --->

<cfparam name="url.step" type="string" default="1">
<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	empty table
	<cfabort>
</cfif>

<!--- load report settings, let modify and start ... --->
<cfinvoke component="#application.components.cmp_crm_reports#" method="GetReportSettings" returnvariable="a_struct_report">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif a_struct_report.q_select_report.recordcount IS 0>
	Report not found.
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_report = a_struct_report.q_select_report />
<cfset a_arr_options = a_struct_report.options />
<cfset a_arr_virtualfields = a_struct_report.virtualfields />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetViewFilters" returnvariable="q_select_filter">
	<cfinvokeargument name="viewkey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset SetHeaderTopInfoString(GetLangVal('crm_wd_report')) />

<cfoutput>
<form name="id_form_create_report" id="id_form_create_report" action="index.cfm?action=StartGenerateReport" method="post" style="margin:0px;" onSubmit="SetReportStarted();">
<input type="hidden" name="frmreportkey" value="<cfoutput>#url.entrykey#</cfoutput>">

	
	
	<br />
	#GetLangVal('crm_ph_generate_report_intro')#
	<br /><br />  
	
	<table class="table table_details table_edit_form">
	  <!---<tr>
	  	<td align="right">
			#GetLangVal('cm_wd_name')#:
		</td>
		<td>
			<input type="text" name="frmname" size="40">
			&nbsp;
			(einen eigenen Namen vergeben)
		</td>
	  </tr>--->
	  <tr>
		<td class="field_name">
			#GetLangVal('cm_wd_description')#
		</td>
		<td>
			#htmleditformat(GetLangVal('crm_ph_default_report_description_' & ReplaceNoCase(q_select_report.entrykey, '-', '', 'ALL')))#
		</td>
		<td></td>
	  </tr>
	  <tr>
		<td class="field_name">
			#GetLangVal('crm_ph_filter')#
		</td>
		<td>
			<select name="frmcrmfilterkey" style="width:350px;">
			
				<option value="thisitemdoesnotexist">#GetLangVal('crm_ph_report_do_not_use_filter')#</option>
				<!--- load other filters ... --->
				<cfloop query="q_select_filters">
					<option title="#htmleditformat(q_select_filters.description)#" value="#q_select_filters.entrykey#">#htmleditformat(q_select_filters.viewname)#</option>
				</cfloop>
				
			</select>
			&nbsp;
			<a href="/addressbook/?action=advancedsearch"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>
		</td>
		<td></td>
	  </tr>
	  
	  <!--- loop through the possible report options ... --->
	  <cfloop from="1" to="#ArrayLen(a_arr_options)#" index="ii">
	  
	  <tr <cfif NOT a_arr_options[ii].visible>style="display:none;"</cfif>>
		<td class="field_name">
			#a_arr_options[ii].name#
		</td>
		<td valign="top">
		
			<cfset a_str_default = a_arr_options[ii].default />
		
			<cfswitch expression="#a_arr_options[ii].datatype#">
				<cfcase value="3">
					<cfif isDate(a_str_default)>
						<cfset a_str_default = DateFormat(a_str_default, request.stUserSettings.default_dateformat)>
					</cfif>
				</cfcase>
			</cfswitch>
		
			<!--- are multiple options provided? if yes, create a select box, otherwise a simple text input ... --->
			<cfif IsArray(a_arr_options[ii].options) AND ArrayLen(a_arr_options[ii].options) GT 0>
				<select name="frm_option_#a_arr_options[ii].entrykey#" <cfif a_arr_options[ii].allow_multi_select_options>multiple size="5"</cfif> style="width:350px; ">
					
					<cfloop from="1" to="#ArrayLen(a_arr_options[ii].options)#" index="a_int_option_index">
						<option
							<cfif a_arr_options[ii].allow_multi_select_options AND a_int_option_index IS 1>selected</cfif>
							value="#htmleditformat(a_arr_options[ii].options[a_int_option_index].key)#">
								#htmleditformat(a_arr_options[ii].options[a_int_option_index].value)#
						</option>
					</cfloop>
				</select>
			<cfelse>
				<input type="text" name="frm_option_#a_arr_options[ii].entrykey#" value="#htmleditformat(a_str_default)#" size="20" style="width:350px; ">
			</cfif>
		
			
			
			<cfswitch expression="#a_arr_options[ii].datatype#">
				<cfcase value="3">
					
					<cfset a_int_rand = RandRange(1, 999999)>
					
					<script type="text/javascript">
						var calendar_#a_int_rand# = new CalendarPopup();
					</script>
					
					<cfset a_str_id = 'anchor_' & a_int_rand>
					<a onClick="calendar_#a_int_rand#.select(document.id_form_create_report.frm_option_#a_arr_options[ii].entrykey#,'#a_str_id#','dd.MM.yy'); return false;" href="##" id="#a_str_id#"><img src="/images/calendar/menu_neuer_eintrag.gif" width="19" height="19" border="0" align="absmiddle"></a>
					<!---<img src="/images/calendar/menu_neuer_eintrag.gif" onClick="alert('n/a yet.');" align="absmiddle">--->
				</cfcase>			
			</cfswitch>
			
			(#a_arr_options[ii].description#)
			
		</td>
		<td>
			
		</td>
	  </tr>
	  </cfloop>
	  
	  <tr>
	  	<td class="field_name">
			#GetLangVal('cm_wd_format')#
		</td>
		<td>
			<select name="frmformat" style="width:350px; ">
				<option value="html">HTML (Browser)</option>
				<option value="excel">CSV (Excel)</option>
				<option value="pdf">PDF (Acrobat Reader)</option>
				<option value="xml">XML (Raw data)</option>
			</select>
		</td>
	  </tr>
	  
	  <!--- create query holding information about fields --->
	 <!---  <cfset q_select_field_informations = QueryNew('fieldname,fieldtype,showname', 'varchar,integer,varchar,')>
			
	  <!--- allow the user to select fields? --->
	  <cfif q_select_report.allow_select_fields IS 1>
	  <tr>
	  	<td class="field_name">
			#GetLangVal('crm_ph_report_displayed_fields')#
		</td>
		<td valign="top">
		
			<cfscript>
				function WriteFieldInformation(fieldname, type, fixed, hidden, description, checked)
					{
					var a_str_output = '';
					var a_str_type = 'checkbox';
					var a_str_showname = fieldname;
					var a_str_checked = 'checked';
					
					if (hidden) {a_str_type = 'hidden';}
					
					if (NOT checked) {a_str_checked = '';}
					
					a_str_output = '<input ' & a_str_checked & ' type="' & a_str_type & '" name="frm_show_fields" value="' & fieldname & '" class="noborder">';
					
					// add output
					if ((NOT hidden) AND (Len(description) GT 0))
						{
						a_str_output = a_str_output & ' ' & description;
						}
						
					// set description ==> showname
					if (Len(description) GT 0)
						{
						a_str_showname = description;
						}
					
					// add meta information about column
					tmp = QueryAddRow(q_select_field_informations, 1);
					tmp = QuerySetCell(q_select_field_informations, 'fieldname', fieldname, q_select_field_informations.recordcount); 
					// always to varchar!
					tmp = QuerySetCell(q_select_field_informations, 'fieldtype', 0, q_select_field_informations.recordcount);
					tmp = QuerySetCell(q_select_field_informations, 'showname', a_str_showname, q_select_field_informations.recordcount);
					
					WriteOutput(a_str_output);
					}
			</cfscript>
		
			<div style="overflow:auto;padding:6px;height:250px;width:350px; " class="b_all">
				
				<cfif q_select_report.basedonaddressbook IS 1>
					<!--- this report is based on the address book - therefore offer the address book fields to be selected --->
					<!---<input type="hidden" name="frm_show_fields" value="entrykey">--->
					
					#WriteFieldInformation('addressbookkey','varchar',true, true, '', true)#
					#WriteFieldInformation('entrykey','varchar',true, true, '', true)#
		
					#WriteFieldInformation('company','varchar',false, false, GetLangVal('adrb_wd_company'), true)#
					<br>
					#WriteFieldInformation('departpment','varchar',false, false, GetLangVal('adrb_wd_department'), true)#
					<br>					
					#WriteFieldInformation('aposition','varchar',false, false, GetLangVal('adrb_wd_position'), true)#
					<br>					
					#WriteFieldInformation('surname','varchar',false, false, GetLangVal('adrb_wd_surname'), true)#
					<br>
					#WriteFieldInformation('firstname','varchar',false, false, GetLangVal('adrb_wd_firstname'), true)#
					<br>
					#WriteFieldInformation('title','varchar',false, false, GetLangVal('adrb_wd_title'), true)#
					<br>
					#WriteFieldInformation('custodians','varchar',false, false, GetLangVal('crm_wd_custodian'), false)#
					<br>
					#WriteFieldInformation('b_country','varchar',false, false, GetLangVal('adrb_wd_country'), false)#
					<br>
					#WriteFieldInformation('b_zipcode','varchar',false, false, GetLangVal('adrb_wd_zipcode'), false)#
					<br>
					#WriteFieldInformation('b_city','varchar',false, false, GetLangVal('adrb_wd_city'), true)#
					<br>
					#WriteFieldInformation('b_telephone','varchar',false, false, GetLangVal('adrb_wd_telephone'), false)#
					<br>
					#WriteFieldInformation('b_mobile','varchar',false, false, GetLangVal('cm_wd_mobile'), false)#
					<br>
					#WriteFieldInformation('b_fax','varchar',false, false, GetLangVal('adrb_wd_fax'), false)#
					<br>					
					#WriteFieldInformation('email_prim','varchar',false, false, GetLangVal('cm_wd_email'), false)#
					<br>
					#WriteFieldInformation('dt_lastcontact','varchar',false, false, GetLangVal('adrb_ph_last_contact'), false)#
					<br>
					#WriteFieldInformation('dt_created','varchar',false, false, GetLangVal('cm_wd_created'), true)#
					<br>
					#WriteFieldInformation('categories','varchar',false, false, GetLangVal('cm_wd_categories'), true)#
					
					
						<cfinvoke component="#request.a_str_component_crm_sales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
							<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
						</cfinvoke>
					
						<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
							
							<cfset variables.a_cmp_database = CreateObject('component', request.a_str_component_database)>
							
							<cfinvoke
								component = "#variables.a_cmp_database#"   
								method = "GetTableFields"   
								returnVariable = "q_table_fields"   
								securitycontext="#request.stSecurityContext#"
								usersettings="#request.stUserSettings#"
								table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#">
							</cfinvoke>
							
								<cfloop query="q_table_fields">
									<cfif ListFindNoCase('addressbookkey', q_table_fields.showname) IS 0>
										<br>
										#WriteFieldInformation('db_' & q_table_fields.fieldname,'varchar',false, false, q_table_fields.showname, false)#	
									</cfif>
								</cfloop>
							
						</cfif>		
				<br>
				</cfif>
				
				
				<!--- now, virtual fields ... no matter what settings applies to the AllowSelectFieldsProperty --->
				<cfloop from="1" to="#ArrayLen(a_arr_virtualfields)#" index="ii">
					<cfset a_struct_field =  a_arr_virtualfields[ii]>
					
					<!--- check if field should be visible to the user ... --->
					<cfif a_struct_field.visible>
					
						<!--- fixed or selectable? --->
						<cfif a_struct_field.fixed>
							#WriteFieldInformation(a_struct_field.entrykey,'varchar',true, true, a_struct_field.fieldname, true)#
							<!---<input type="hidden" name="frm_show_fields" value="#a_struct_field.entrykey#">--->
							<input type="checkbox" name="frm_dummy_cb" class="noborder" checked disabled>
							#a_struct_field.fieldname#
							<br>
						<cfelse>
							#WriteFieldInformation(a_struct_field.entrykey,'varchar',false, false, a_struct_field.fieldname, true)#
							<!---<input #WriteCheckedElement(a_struct_field.selected, true)# type="checkbox" class="noborder" name="frm_show_fields" value="#a_struct_field.entrykey#"> #a_struct_field.fieldname#--->
							<br>
						</cfif>
					<cfelse>
						<!--- completly hidden ... --->
						#WriteFieldInformation(a_struct_field.entrykey,'varchar',true, true, a_struct_field.fieldname, true)#
						<!---<input type="hidden" name="frm_show_fields" value="#a_struct_field.entrykey#">--->
					</cfif>
				</cfloop>				
					
			</div>
			
			
		</td>
	  </tr>
	  </cfif>	 --->	  
	  <tr>
		<td>&nbsp;</td>
		<td>
			<input type="submit" value="#GetLangVal('crm_ph_reports_execute_now')#" class="btn btn-primary">
		</td>
	  </tr>
	</table>

<!--- <cfwddx action="cfml2wddx" input="#q_select_field_informations#" output="a_str_html_field_information">
<input type="hidden" name="frm_field_information" value="#htmleditformat(a_str_html_field_information)#"> --->

</form>
</cfoutput>

<!---<cfdump var="#q_select_field_informations#">--->

<div style="display:none; " id="id_div_status_create_report" class="default_fieldset">
	<cfoutput>#GetLangVal('cm_wd_status')#</cfoutput>
	<div>
		<cfset a_str = GetLangval('crm_ph_report_is_being_executed')>
		<cfset a_str = ReplaceNoCase(a_str, '%REPORTNAME%', '<b>' & GetLangVal('crm_ph_default_report_name_' & ReplaceNoCase(q_select_report.entrykey, '-', '', 'ALL')) & '</b>', 'ALL')>
		
		<cfoutput>#a_str#</cfoutput>
		<br><br>
		<input type="button" onClick="javascript:history.go(-1);" value="<cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput>" class="btn" />
	</div>
	<div id="id_div_status_create_report_will_take_longer" style="display:none;padding:8px;" class="mischeader">
		<cfoutput>#GetLangVal('crm_report_will_take_longer_create_notification_description')#</cfoutput>
		<br><br>
		<a style="font-weight:bold; " href="utils/act_cancel_waiting_for_report.cfm"><cfoutput>#GetLangVal('crm_report_will_take_longer_create_notification_link')#</cfoutput></a>
	</div>
</div>

<script type="text/javascript">
	function SetReportStarted() {
		var obj1 = findObj('id_div_status_create_report');
		var a_simple_modal_dialog = new cSimpleModalDialog();
		a_simple_modal_dialog.type = 'custom';
		a_simple_modal_dialog.customtitle = 'titel dieses fensters';
		a_simple_modal_dialog.customcontent = obj1.innerHTML;
		// show dialog
		a_simple_modal_dialog.ShowDialog();		
		
		window.setTimeout("NotifyAboutFinishedReportByEmail()", 5000);
		}
		
	function NotifyAboutFinishedReportByEmail() {
		var obj1 = findObj('id_div_status_create_report_will_take_longer');
		obj1.style.display = '';
		}
</script>


