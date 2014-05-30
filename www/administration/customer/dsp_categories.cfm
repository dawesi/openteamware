<!--- //

	Module:		admintool
	action:		companycategories
	Description: 
	
// --->


<cfinclude template="../dsp_inc_select_company.cfm">

<cfinclude template="queries/q_select_categories.cfm">
<br>
<cfoutput>#GetLangVal('adm_ph_company_default_categories_description')#</cfoutput>
<br>
<form action="customer/act_set_company_categories.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>
		<textarea name="frmcategories" cols="40" rows="10"><cfoutput>#htmleditformat(q_select_categories.company_default_categories)#</cfoutput></textarea>
	</td>
  </tr>
  <tr>
    <td>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" class="btn btn-primary" />
	</td>
  </tr>
</table>
</form>


