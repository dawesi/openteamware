
<cfinclude template="dsp_inc_select_reseller.cfm">

<cfinclude template="queries/q_select_companies.cfm">



<cfquery name="q_select_companies" dbtype="query">
SELECT
	*
FROM
	q_select_companies
WHERE
	status = 1
;
</cfquery>
<h4 style="margin-bottom:3px;"><cfoutput>#GetLangVal('adm_wd_nav_interested_parties ')#</cfoutput> (<cfoutput>#q_select_companies.recordcount#</cfoutput>)</h4>

<br>

<table border="0" cellspacing="0" cellpadding="3">
  <tr class="lightbg">
    <td><cfoutput>#GetLangVal('adm_wd_customer')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_created')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput></td>
  </tr>
<cfoutput query="q_select_companies">
  <tr>
    <td>#q_select_companies.companyname#</td>
    <td>
	#q_select_companies.dt_created#
	</td>
    <td>
	#q_select_companies.description#
	</td>
  </tr>
</cfoutput>
</table>