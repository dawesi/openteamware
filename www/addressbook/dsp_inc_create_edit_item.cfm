<!--- //

	Module:		Address Book
	Action:		Create / edit item
	Description:Display form and operations ...
	

// --->

<!--- action: CREATE or UPDATE --->
<cfparam name="CreateEditItem.Action" type="string" default="Create">

<!--- query holding existing data --->
<cfparam name="CreateEditItem.Query" type="query" default="#QueryNew('abc')#">

<!--- entrykey of item ... --->
<cfparam name="CreateEditItem.Entrykey" type="string" default="">

<!--- 0 = contact,
	  1 = account,
	  2 = lead or
	  3 = archive/pool ...
	  9 = own vcard --->
<cfparam name="CreateEditItem.Datatype" type="numeric" default="0">

<cfset a_struct_force_element_values = StructNew() />

<!--- force to set entrykey ... --->
<cfset a_struct_force_element_values.entrykey = CreateEditItem.Entrykey />

<!--- Remote Edit data available? ... --->
<cfif (CreateEditItem.Action IS 'UPDATE') AND
	  (ListFindNoCase(CreateEditItem.query.columnlist, 'is_re_data_available') GT 0) AND
	  (CreateEditItem.query.is_re_data_available GT 0)>
		
		<cfset q_select_remote_edit_data = application.components.cmp_addressbook.GetRemoteEditData(entrykey = CreateEditItem.Entrykey) />
		
		<cfif q_select_remote_edit_data.recordcount GT 0>
			<cfset q_select_form_fields = application.components.cmp_forms.GetFormFields(formkey = 'A91C770B-ED89-F6E4-7A78E991E6FEFCD1') />
			
			<cfset a_str_db_fields = ValueList(q_select_form_fields.db_fieldname) />
			
			<div class="bb" style="padding:8px;">
			<h4 style="margin-bottom:5px;"><cfoutput>#si_img('exclamation')# #GetLangVal('adrb_ph_remoteedit_contact_has_updated_data1')#</cfoutput></h4>
			
			<cfloop list="#q_select_remote_edit_data.columnlist#" index="a_str_col">
				
				<cfset a_str_possible_new_value = q_select_remote_edit_data[a_str_col][1] />
				<!---
				
					data must exist in given query, in form, must be different from existing data and not an empty string
				
					--->
				
				<cfif (ListFindNoCase(CreateEditItem.query.columnlist, a_str_col) GT 0) AND
					  (Len(a_str_possible_new_value) GT 0) AND
					  (CompareNoCase(CreateEditItem.query[a_str_col][1], a_str_possible_new_value) NEQ 0) AND
					  (ListFindNoCase(a_str_db_fields, a_str_col) GT 0)>
						  
					<cfquery name="q_select_form_element" dbtype="query">
					SELECT
						field_name,input_name
					FROM
						q_select_form_fields
					WHERE
						UPPER(db_fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(a_str_col)#">
					;
					</cfquery>
					
					<cfset a_str_old_value = '<br /><span>' & JsStringFormatEx(CreateEditItem.query[a_str_col][1]) & '</span>' />
					<cfset tmp = AddJSToExecuteAfterPageLoad('$("###q_select_form_element.input_name#").parent().append(''#a_str_old_value#'').css(''backgroundColor'', ''orange'');', '') />
						
					<cftry>
					<cfset tmp = QuerySetCell(CreateEditItem.query, a_str_col, a_str_possible_new_value, 1) />
					<cfcatch type="any"></cfcatch>
					</cftry>
					
				</cfif>
			</cfloop>
			
			</div>
		
		</cfif>
			
</cfif>

<!--- display some fields, which are hidden by default and disable
		some others, which are enabled by default ... --->

<cfset sEntrykeys_fields_to_ignore = '' />
<cfset a_str_db_fields_to_ignore = '' />
<cfset sEntrykeys_fields_show_force = '' />

<cfswitch expression="#createedititem.datatype#">
	<cfcase value="0">
		<!--- contact ... --->
		<cfset a_str_db_fields_to_ignore = 'employees' />
		
	</cfcase>
	<cfcase value="1">
		<!--- account ... --->
		
		<!--- firstname, title, surname, account ... --->
		<cfset a_str_db_fields_to_ignore = 'sex,title,firstname,surname,birthday,company,skypeusername,aposition' />
		
		<!--- birthday ... --->
		<!--- account ... ignore private address data --->
		<cfset a_str_db_fields_to_ignore = ListAppend(a_str_db_fields_to_ignore, 'p_city,p_mobile,p_fax,p_telephone,p_zipcode,p_country,p_street,superiorcontactkey') />
		
		<!--- spacer fields ...--->
		<cfset sEntrykeys_fields_to_ignore = '77788A08C-F6E5-79BF-8E1A0C5EF593C7E6,SS92P5C9B-93B4-6521-AC78EC783F1E25B,A8A8SA9SA-F135-7F64-EFF3BBAF549EC319,X90F98CB-DCF2-7880-91BB730A00257A9B,X90pp3CB-DCF2-0d90-91BB730A00257A9B,X90F33CB-DCF2-7880-91BB730A00257A9B,X90F33CB-DCF2-0d90-91BB730A00257A9B' />
	
		<cfset sEntrykeys_fields_show_force = 'PJK2DA3D-A80C-2789-660A313A2D30F34D,XII1D1EB-D078-9D5A-FE5794ADA4BD37D6' />
		
	</cfcase>
	<cfcase value="2">
		<!--- lead ... --->
		
		
	</cfcase>
	<cfcase value="9">
		<!--- own vcard ... --->
		<cfset a_str_db_fields_to_ignore = 'employees,nace_code,custodian,criteria,categories,virtual_workgroupshares_data,virtual_assignedusers_data,superiorcontactkey,notice,virt_notices_private_data' />
	</cfcase>
</cfswitch>

<!--- some modifications for users without workgroups ... --->
<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount IS 0>
	<!--- no workgroup selection ... --->
	<cfset sEntrykeys_fields_to_ignore = ListAppend(sEntrykeys_fields_to_ignore, 'P49F48A-EAEB-E99B-6FB79312BB368940') />
	
	<!--- no setting of custodians ... --->
	<cfset sEntrykeys_fields_to_ignore = ListAppend(sEntrykeys_fields_to_ignore, '847305EF-EE7A-EE49-900A2F5C57E185A6') />
</cfif>

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = CreateEditItem.action,
						query = CreateEditItem.query,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = 'A91C770B-ED89-F6E4-7A78E991E6FEFCD1',
						force_element_values = a_struct_force_element_values,
						objectkey = CreateEditItem.entrykey,
						dbfieldnames_to_ignore = a_str_db_fields_to_ignore,
						entrykeys_fields_force_to_show = sEntrykeys_fields_show_force,
						entrykeys_fields_to_ignore = sEntrykeys_fields_to_ignore) />

<cfoutput>#a_str_form#</cfoutput>