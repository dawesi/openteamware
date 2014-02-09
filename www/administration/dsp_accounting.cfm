<!--- //



	accounting / verrechnung

	

	// --->

<cfinclude template="dsp_inc_select_company.cfm">
	
<cfset SelectBookedServices.companykey = url.companykey>
<cfinclude template="queries/q_select_booked_services.cfm">


<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif (q_select_company_data.settlement_type IS 1)>
	<br>
	<fieldset>
		<legend><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput></legend>
		<div>
			<cfoutput>#GetLangVal('adm_ph_transparent_reseller_hint_shop')#</cfoutput> 
		</div>
	</fieldset>
	<br>
</cfif>		

<h4><cfoutput>#GetLangVal('adm_ph_close_order')#</cfoutput></h4>

<cfquery name="q_select_open_services" dbtype="query">
SELECT
	*
FROM
	q_select_booked_services
WHERE
	paid = 0
;
</cfquery>

<b><font color="#CC0000"><cfoutput>#GetLangVal('adm_ph_open_items_in_basket')#</cfoutput></font></b>
<br>
<table border="0" cellspacing="0" cellpadding="4">
  <form action="default.cfm" method="get">

  <input type="hidden" name="action" value="generatebill">
  <input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
  <input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">



  <tr class="lightbg">

    <td>&nbsp;</td>

	<td>&nbsp;</td>

    <td><cfoutput>#GetLangVal('cm_wd_title')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('adm_wd_sum')#</cfoutput></td>

  </tr>

  <cfoutput query="q_select_open_services">

  <input name="frmorderid" type="hidden" value="#q_select_open_services.entrykey#">

  <tr>

    <td align="right" style="color:silver;">#q_select_open_services.currentrow#</td>

	<td>#q_select_open_services.quantity#x</td>

    <td>#q_select_open_services.productname#</td>

    <td align="right">#q_select_open_services.totalamount# &euro;</td>

  </tr>

  </cfoutput>

  

  <cfquery name="q_select_sum" dbtype="query">

  SELECT SUM(totalamount) AS total_sum FROM q_select_open_services;

  </cfquery>

  

  <tr>

  	<td colspan="3" align="right"><cfoutput>#GetLangVal('adm_wd_sum')#</cfoutput>:</td>

	<td align="right">

	<cfoutput>#DecimalFormat(q_select_sum.total_sum)#</cfoutput> &euro;

	</td>

  </tr>

  

 <!--- <cfif request.a_bol_is_reseller is true>

  <!--- reseller can enter remissions ... --->

  <tr>

  	<td colspan="4">

	Nachlass geben

	</td>

  </tr>

  <tr>

  	<td colspan="3" align="right">

	<input type="text" name="frmdiscountdescription" size="30">

	</td>

	<td align="right">

	<input type="text" name="frmdiscount" size="4" value="0"> &euro;

	</td>

  </tr>

  </cfif>  --->

  <tr>

	<td colspan="4" align="right">
	
	<cfif request.a_bol_is_reseller>
	<cfoutput>#GetLangVal('adm_wd_comment')#</cfoutput>: <input type="text" name="frmcomment" size="30"><br><br><br>
	</cfif>

	<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_btn_submit_close_order')#</cfoutput>" style="font-weight:bold;">

	<br>
	<cfoutput>#GetLangVal('adm_ph_btn_submit_close_order_hint')#</cfoutput>
	</td>

  </tr>
  <!---<cfif request.a_bol_is_reseller>
  <tr>
  	<td colspan="4" align="right" style="border-top:silver solid 1px;color:gray;">
	<input type="submit" name="frmsubmit" value="Anbot abschliessen" disabled>
	<br>
	Ein PDF mit einem Anbot ueber die<br>
	gewaehlten Produkte erstellen ...
	<br>dieses kann dann direkt weitergemailt werden.
	</td>
  </tr>
  </cfif>--->

  </form>  

</table>