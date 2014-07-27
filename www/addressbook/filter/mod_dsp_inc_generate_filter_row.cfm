<!--- //

	Module:		Address Book
	Description:Generate a filter row ...
	

// --->

<cfinclude template="/common/scripts/script_utils.cfm">

<!--- and/or/and not --->
<cfparam name="attributes.AndOr" type="string" default="and">

<!--- name of the field --->
<cfparam name="attributes.FieldName" type="string">

<!--- display name of field --->
<cfparam name="attributes.DisplayName" type="string">

<!--- string/number/select/textarea/date/boolean ... specials (criteria workgroups, followups, events, ...) --->
<cfparam name="attributes.FieldType" type="string">

<!--- fieldsource ... contact/meta/database --->
<cfparam name="attributes.FieldSource" type="string" default="addressbook">

<!--- entrykey if existing filter --->
<cfparam name="attributes.FilterItemEntrykey" type="string" default="">

<!--- compare operator ... --->
<cfparam name="attributes.CompareOperator" type="numeric" default="-1">

<!--- compare value --->
<cfparam name="attributes.CompareValue" type="string" default="">

<!--- options? array with items ... option value|display value --->
<cfparam name="attributes.CompareOptions" type="array" default="#ArrayNew(1)#">

<!--- display - or not? --->
<cfparam name="attributes.displayatstart" type="boolean" default="true">

<!--- offer the delete criteria of an element? --->
<cfparam name="attributes.OfferResetButton" type="boolean" default="true">


<!--- now, write output ... --->
<cfset a_str_uuid_item = '_' & CreateUUID() />
<cfset a_str_tr_id = 'id_tr_field' & htmleditformat(a_str_uuid_item) />

<cfsavecontent variable="a_str_js">
<cfswitch expression="#attributes.FieldSource#">
	<cfcase value="contact">
		a_arr_fields_contacts[a_arr_fields_contacts.length] = '<cfoutput>#a_str_tr_id#</cfoutput>';
	</cfcase>
	<cfcase value="database">
		a_arr_fields_database[a_arr_fields_database.length] = '<cfoutput>#a_str_tr_id#</cfoutput>';		
	</cfcase>
	<cfcase value="meta">
		a_arr_fields_meta[a_arr_fields_meta.length] = '<cfoutput>#a_str_tr_id#</cfoutput>';		
	</cfcase>
</cfswitch>
</cfsavecontent>

<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />

<cfoutput>
<input type="hidden" name="frmfieldnames" value="#htmleditformat(attributes.fieldname)#">
<input type="hidden" name="frmfieldUUID#attributes.fieldname#" value="#htmleditformat(a_str_uuid_item)#">

<input type="hidden" name="frmshownamename#a_str_uuid_item#" value="#htmleditformat(attributes.DisplayName)#">
<input type="hidden" name="frmFieldType#a_str_uuid_item#" value="#htmleditformat(attributes.FieldType)#">
<input type="hidden" name="frmFieldSource#a_str_uuid_item#" value="#htmleditformat(attributes.FieldSource)#">

<!--- use fix AND --->
<input type="hidden" name="frm_and_or#a_str_uuid_item#" value="and">

<!---  style="<cfif NOT attributes.displayatstart>display:none;</cfif>" --->
<tr id="#a_str_tr_id#">

	<td class="field_name" id="id_td_displayname#a_str_uuid_item#">
		#htmleditformat(attributes.DisplayName)#
	</td>
	
	<cfif CompareNoCase(attributes.FieldType, 'criteria') NEQ 0>
	<td>
		<select name="frmoperator#a_str_uuid_item#" onChange="CheckShowCriteriaUsed(this, '#jsstringformat(a_str_uuid_item)#');">
			<option value="-1"></option>
			
			<cfif CompareNoCase(attributes.FieldType, 'string') IS 0>
				<!--- string compare --->
				<option value="0"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="1"><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>
				<option value="4"><cfoutput>#GetLangVal('crm_wd_filter_operator_4')#</cfoutput></option>
				<option value="5"><cfoutput>#GetLangVal('crm_wd_filter_operator_5')#</cfoutput></option>
			</cfif>
			
			<cfif CompareNoCase(attributes.FieldType, 'number') IS 0>
				<!--- string compare --->
				<option value="0"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="1"><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>
				<option value="2"><cfoutput>#GetLangVal('crm_wd_filter_operator_2')#</cfoutput></option>
				<option value="3"><cfoutput>#GetLangVal('crm_wd_filter_operator_3')#</cfoutput></option>
			</cfif>			
			
			<cfif CompareNoCase(attributes.FieldType, 'boolean') IS 0>
				<option value="0"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="1"><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>
			</cfif>
			
			<!---<cfif CompareNoCase(attributes.FieldType, 'criteria') IS 0>
				<option value="6">NEW: LISTCONTAINS <cfoutput>#GetLangVal('crm_wd_filter_operator_6')#</cfoutput></option>
			</cfif>--->
			
			<cfif CompareNoCase(attributes.FieldType, 'select') IS 0>
			
				<!--- if contact data, allow CONTAINS and BEGINS WITH! --->
				<cfif CompareNoCase(attributes.FieldSource, 'contact') IS 0>
					<option value="4"><cfoutput>#GetLangVal('crm_wd_filter_operator_4')#</cfoutput></option>
					<option value="5"><cfoutput>#GetLangVal('crm_wd_filter_operator_5')#</cfoutput></option>
				</cfif>
				
				<option value="0"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="1"><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>				
			</cfif>
			
			<cfif CompareNoCase(attributes.FieldType, 'multiselect') IS 0>
				<option value="4"><cfoutput>#GetLangVal('crm_wd_filter_operator_4')#</cfoutput></option>		
			</cfif>			
			
			<cfif CompareNoCase(attributes.FieldType, 'date') IS 0>
				<option value="0"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="2"><cfoutput>#GetLangVal('crm_wd_filter_operator_2')#</cfoutput></option>
				<option value="3"><cfoutput>#GetLangVal('crm_wd_filter_operator_3')#</cfoutput></option>
			</cfif>			
			
		</select>
	</td>
	<cfelse>
		<!--- display nothing ... criteria select does not need a second select box --->
		<td>
			<select name="frmoperator#a_str_uuid_item#">
				<option value="-1"></option>
				<option value="6"><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>
				<option value="1"><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>
			</select>
		</td>
	</cfif>
	
	
	<td>
		<cfswitch expression="#attributes.FieldType#">
			<cfcase value="select,multiselect">
				<!--- multiple ... --->
				
				<cfif attributes.FieldType IS 'select'>
					<cfset a_int_select_size = 1>
				<cfelse>
					<cfset a_int_select_size = 5>				
				</cfif>
				
				<select size="#a_int_select_size#" <cfif attributes.FieldType IS 'multiselect'>multiple</cfif>  onChange="CheckCompareValueSelected('#jsstringformat(a_str_uuid_item)#');" name="frmcompare#a_str_uuid_item#">
					<!--- default value (empty) --->
					<option value=""></option>
					
					<cfloop from="1" to="#ArrayLen(attributes.CompareOptions)#" index="ii">
						
						<cfset a_str_option_value = ListGetAt(attributes.CompareOptions[ii], 1)>
						
						<cfif ListLen(attributes.CompareOptions[ii]) GT 1>
							<cfset a_str_option_display = ListGetAt(attributes.CompareOptions[ii], 2)>
						<cfelse>
							<cfset a_str_option_display = a_str_option_value>
						</cfif>
					
						<option value="#htmleditformat(a_str_option_value)#">#htmleditformat(a_str_option_display)#</option>
					</cfloop>
				</select>
			</cfcase>
			<cfcase value="date">
				<input type="text" name="frmcompare#a_str_uuid_item#" value="" size="20"> <img src="/images/si/calendar.png" class="si_img" />
			</cfcase>
			<cfcase value="number">
				<input onKeyPress="CheckCompareValueSelected('#jsstringformat(a_str_uuid_item)#');" type="text" name="frmcompare#a_str_uuid_item#" value="#htmleditformat(attributes.CompareValue)#" size="10">
			</cfcase>
			<cfcase value="boolean">
				wahr
				<input type="hidden" name="frmcompare#a_str_uuid_item#">				
			</cfcase>
			<cfcase value="criteria">
				
				<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn">
					<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
					<cfinvokeargument name="options" value="allowedit">
					<cfinvokeargument name="selected_ids" value="">
					<cfinvokeargument name="form_input_name" value="frmcompare#a_str_uuid_item#">
				</cfinvoke>
				
				<div style="height:160px;overflow:auto; ">
				#sReturn#
				</div>
				
			</cfcase>
			<cfdefaultcase>
				<!--- onchange ... check if the compare operator is -1 ... if yes, change to the first item ... --->
				<input onKeyPress="CheckCompareValueSelected('#jsstringformat(a_str_uuid_item)#');" type="text" name="frmcompare#a_str_uuid_item#" value="#htmleditformat(attributes.CompareValue)#" size="20">
			</cfdefaultcase>
		</cfswitch>
		
	</td>
	<td>
		<!--- reset criteria --->
		<cfif attributes.OfferResetButton>
			<input type="button" class="btn" value="#GetLangVal('cm_wd_reset')#..." />
			<!---<a href="javascript:ResetFilterCriteria('#jsstringformat(a_str_uuid_item)#');"><img src="/images/si/delete.png" align="absmiddle" border="0" /></a>--->
		<cfelse>
			&nbsp;
		</cfif>
	</td>
</tr>
</cfoutput>

