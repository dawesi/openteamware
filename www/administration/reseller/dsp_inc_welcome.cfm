<!--- neue registrierungen/interessenten ---->

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	companyname,customerid,dt_created,email,entrykey
FROM
	companies
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
	AND
	status = 1
	AND
	disabled = 0
ORDER BY
	dt_created DESC
;
</cfquery>


<h4>Neue Interessenten (<cfoutput>#q_select_companies.recordcount#</cfoutput>)</h4>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td class="bb">&nbsp;</td>
    <td class="bb">Name</td>
    <td class="bb">Kdn-Nr.</td>
    <td class="bb">erstellt.</td>
  </tr>
  <cfoutput query="q_select_companies" startrow="1" maxrows="20">
  <tr <cfif q_select_companies.currentrow MOD 2 IS 0>class='lightbg'</cfif>>
    <td>
		###q_select_companies.currentrow#
	</td>
    <td>
		<a href="default.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_companies.entrykey)#&resellerkey=#url.resellerkey#">#htmleditformat(q_select_companies.companyname)#</a>
	</td>
    <td>
		#q_select_companies.customerid#
	</td>	
    <td>
		#DateFormat(q_select_companies.dt_created, 'dd.mm.yy')#
	</td>
  </tr>
  </cfoutput>
  <cfif q_select_companies.recordcount GT 20>
  	<tr class="mischeader">
		<td colspan="4">
			<a href="default.cfm?action=customers&resellerkey=<cfoutput>#url.resellerkey#</cfoutput>&frmstatus=1"><b>jetzt alle Interessenten anzeigen ...</b></a>
		</td>
	</tr>
  </cfif>
</table>


<!--- neue customers --->


<!--- mitteilungen --->