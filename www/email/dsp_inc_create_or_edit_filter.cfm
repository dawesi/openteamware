<!--- //



	common form for creating/editing filter

	

	//--->



<cfparam name="CreateEditFilterRequest.Filtername" type="string" default="">

<cfparam name="CreateEditFilterRequest.Filteraction" type="numeric" default="1">

<cfparam name="CreateEditFilterRequest.filterparam" type="string" default="">

<cfparam name="CreateEditFilterRequest.SubmitBtnCaption" type="string" default="">

<cfparam name="CreateEditFilterRequest.comparisonfield" type="numeric" default="0">

<cfparam name="CreateEditFilterRequest.comparison" type="numeric" default="0">

<cfparam name="CreateEditFilterRequest.comparisonparam" type="string" default="">

<cfparam name="CreateEditFilterRequest.stoponsuccess" type="numeric" default="1">

<cfparam name="CreateEditFilterRequest.antispamfilter" type="numeric" default="0">



<script type="text/javascript" src="../common/js/display.js"></script>



<script type="text/javascript">

	function ChangeFilterAction(wert)

		{

		obj1 = findObj('idtrfilteraction1');

		obj2 = findObj('idtrfilteraction2');

		

		obj1.style.display = "none";

		obj2.style.display = "none";

		

		if (wert == "1")

			{

			obj1.style.display = "";

			}

			

		if (wert == "2")

			{

			obj2.style.display = "";

			}

		}

</script>



<cfquery name="request.q_select_folders" dbtype="query">

SELECT * FROM request.q_select_folders

WHERE NOT fullfoldername = 'INBOX';

</cfquery>



<table border="0" cellspacing="0" cellpadding="4">

  <tr class="mischeader">

    <td align="right" width="90">

	<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:

	</td>

    <td>
		<input type="text" name="frmFiltername" size="25" maxlength="100" value="<cfoutput>#htmleditformat(CreateEditFilterRequest.Filtername)#</cfoutput>">
	</td>

  </tr>

  <tr>

    <td align="right">

	<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>:

	</td>

    <td>

	<select name="frmFilterAction" id="frmFilterAction" onChange="ChangeFilterAction(this.value);">

		<option value="0" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.Filteraction, 0)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput></option>

		<option value="1" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.Filteraction, 1)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_move')#</cfoutput></option>

		<option value="2" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.Filteraction, 2)#</cfoutput>><cfoutput>#GetLangVal('mail_ph_filter_action_forward')#</cfoutput></option>

	</select>	

	</td>

  </tr>

  <tr id="idtrfilteraction1" style="display:none;">

    <td align="right"><cfoutput>#GetLangVal('mail_ph_filter_target_folder')#</cfoutput>:</td>

    <td>

	<select name="frmdestinationfolder">

		<cfoutput query="request.q_select_folders">

		<option #WriteSelectedElement(CreateEditFilterRequest.filterparam, request.q_select_folders.fullfoldername)# value="#htmleditformat(request.q_select_folders.fullfoldername)#">#htmleditformat(request.q_select_folders.foldername)#</option>

		</cfoutput>

	</select>	

	</td>

  </tr>

  <tr id="idtrfilteraction2" style="display:none;">

  	<td align="right"><cfoutput>#GetLangVal('mail_ph_filter_target_address')#</cfoutput>:</td>

	<td>

	<input name="frmdestinationemailaddress" type="text" size="25" maxlength="100" value="<cfoutput>#htmleditformat(CreateEditFilterRequest.filterparam)#</cfoutput>">

	</td>

  </tr>

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_ph_filter_search_in')#</cfoutput>:</td>

    <td>

	<select name="frmcomparisonfield">

		<option value="0" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 0)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput></option>

		<option value="1" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 1)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_sender')#</cfoutput></option>

		<option value="2" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 2)#</cfoutput>><cfoutput>#GetLangVal('mail_wd_recipient')#</cfoutput></option>

		<option value="3" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 3)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_priority')#</cfoutput></option>

		<option value="4" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 4)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_size')#</cfoutput></option>

		<option value="5" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparisonfield, 5)#</cfoutput>><cfoutput>#GetLangVal('mail_ph_filter_full_header')#</cfoutput></option>

	</select>

	&nbsp;

	<select name="frmcomparison">

		<option value="0" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 0)#</cfoutput>><cfoutput>#GetLangVal('crm_wd_filter_operator_0')#</cfoutput></option>

		<option value="1" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 1)#</cfoutput>><cfoutput>#GetLangVal('crm_wd_filter_operator_1')#</cfoutput></option>

		<option value="2" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 2)#</cfoutput>><cfoutput>#GetLangVal('crm_wd_filter_operator_4')#</cfoutput></option>

		<!---<option value="3" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 3)#</cfoutput>>enth&auml;lt nicht</option>--->

		<option value="4" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 4)#</cfoutput>><cfoutput>#GetLangVal('crm_wd_filter_operator_2')#</cfoutput></option>

		<option value="5" <cfoutput>#WriteSelectedElement(CreateEditFilterRequest.comparison, 5)#</cfoutput>><cfoutput>#GetLangVal('crm_wd_filter_operator_3')#</cfoutput></option>

	</select>	

	</td>

  </tr>

  <tr>

    <td align="right"><cfoutput>#GetLangVal('mail_ph_filter_comparison')#</cfoutput>:</td>

    <td>

	<input type="text" name="frmcomparisonparam" size="25" maxlength="100" value="<cfoutput>#htmleditformat(CreateEditFilterRequest.comparisonparam)#</cfoutput>">

	</td>

  </tr>

  <tr>

  	<td>&nbsp;</td>

	<td>

	<input value="1" type="checkbox" name="frmantispamfilter" <cfoutput>#WriteCheckedElement(CreateEditFilterRequest.antispamfilter, 1)#</cfoutput> class="noborder"> <cfoutput>#GetLangVal('mail_ph_filter_is_anti_spam')#</cfoutput>

	</td>

  </tr>

  <tr>

  	<td>&nbsp;</td>

	<td><input type="checkbox" <cfoutput>#WriteCheckedElement(CreateEditFilterRequest.stoponsuccess, 1)#</cfoutput> class="noborder" name="frmstoponsuccess" value="1"> <cfoutput>#GetLangVal('mail_ph_filter_stop_proceeding')#</cfoutput></td>

  </tr>

  <tr>

    <td>&nbsp;</td>

    <td><input type="submit" name="frmSubmit" value="<cfoutput>#htmleditformat(CreateEditFilterRequest.SubmitBtnCaption)#</cfoutput>"></td>

  </tr>

  <tr>

  	<td class="bt">&nbsp;</td>

	<td class="bt">

	<a href="default.cfm?action=filter"><cfoutput>#GetLangVal('cm_ph_go_back_without_modifications')#</cfoutput></a>

	</td>

  </tr>

</table>





<!--- display right field ... --->

<script type="text/javascript">

	ChangeFilterAction('<cfoutput>#CreateEditFilterRequest.Filteraction#</cfoutput>');

</script>



<script type="text/javascript">
	function CheckFormData()
		{

		if (document.formfilter.frmcomparisonparam.value == "")
			{
			alert('<cfoutput>#GetLangValJS('mail_ph_filter_empty_compare_value')#</cfoutput>');
			return false;
			}

		}
</script>

<br /><br /><br />

	<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
		<cfinvokeargument name="section" value="mail">
		<cfinvokeargument name="langno" value="#client.langno#">
		<cfinvokeargument name="template_name" value="filter_examples_and_hints">
	</cfinvoke>
	
	<cfinclude template="#a_str_page_include#">	