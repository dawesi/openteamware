<!--- //

	extend trial phase
	
	// --->
	
<cfinclude template="../dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<br><br>
<cfif q_select_company_data.status IS 0>
	<b>Ist bereits Kunde.</b>
	<cfexit method="exittemplate">
</cfif>

<table border="0" cellspacing="0" cellpadding="6">
<form action="customer/act_extend_trial_phase.cfm" method="post">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_new_trial_end')#</cfoutput>:
	</td>
    <td>
		<input type="text" name="frmdt_trial_end" value="<cfoutput>#DateFormat(q_select_company_data.DT_TRIALPHASE_END, 'dd.mm.yyyy')#</cfoutput>" size="10"> dd.mm.yyyy
	</td>
  </tr>
  <!---<tr>
    <td align="right">
		Kunden per E-Mail informieren?
	</td>
    <td>
		<select name="frmselect">
			<option value="1">Ja</option>
			<option value="0">Nein</option>
		</select>
	</td>
  </tr>--->
  <tr>
    <td>&nbsp;</td>
    <td>
	<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>">
	</td>
  </tr>
 </form>
</table>


