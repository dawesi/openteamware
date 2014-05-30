<!--- //

	2do: delete all criterias without saved settings ...
	
	// --->
<cfparam name="url.resetallunsavedcriterias" type="boolean" default="true">
<cfparam name="url.filterviewkey" type="string" default="">

<form action="/addressbook/crm/act_add_filter_criteria.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.filterviewkey)#</cfoutput>">
<input type="hidden" name="frmredirect" value="addressbook">

<table class="table_details">
	<!--- display the reset option only if unsaved filterviewkey --->
	<tr class="mischeader" <cfif Len(url.filterviewkey) GT 0>style="display:none;"</cfif>>
		<td class="bb"></td>
		<td colspan="4" class="bb">
			<input value="1" class="noborder" type="checkbox" <cfif url.resetallunsavedcriterias>checked</cfif> name="frm_reset_all_criterias"> <cfoutput>#GetLangVal('crm_ph_delete_all_other_unsaved_criteria')#</cfoutput>
		</td>
	</tr>
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="surname"
		DisplayName="#GetLangVal('adrb_wd_surname')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>

  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="firstname"
		DisplayName="#GetLangVal('adrb_wd_firstname')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="company"
		DisplayName="#GetLangVal('adrb_wd_company')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_country"
		DisplayName="#GetLangVal('adrb_wd_country')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>					
		
  <!---<cfset a_arr_options = ArrayNew(1)>
  <cfset a_arr_options[1] = '0,male'>
  <cfset a_arr_options[2] = '1,female'>--->
	
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_zipcode"
		DisplayName="#GetLangVal('adrb_wd_zipcode')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_city"
		DisplayName="#GetLangVal('adrb_wd_city')#"
		FieldType="string"
		FieldSource="contact"
		displayatstart=true
		OfferResetButton=false>			
		<tr>
			<td colspan="2"></td>
			<td colspan="3">
				<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>">
			</td>
		</tr>
</table>
</form>