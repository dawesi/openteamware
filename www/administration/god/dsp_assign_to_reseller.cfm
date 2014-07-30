

<cfquery name="q_select_companies">
SELECT
	companyname,entrykey,description,telephone,contactperson,email,resellerkey
FROM
	companies
WHERE
	status = 1
	AND
	assignedtoreseller = 0
	AND
	disabled = 0
;
</cfquery>
<br>
<!---<cfdump var="#q_select_companies#">--->
<cfoutput>#q_select_companies.recordcount#</cfoutput> Eintraege
<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<cfoutput query="q_select_companies" startrow="1" maxrows="20">
  <tr>
    <td>
		<a target="_blank" href="../index.cfm?action=customerproperties&companykey=#urlencodedformat(q_select_companies.entrykey)#&resellerkey=#urlencodedformat(q_select_companies.resellerkey)#">#q_select_companies.companyname#</a>
	</td>
    <td>
		#q_select_companies.description#
	</td>
    <td>
		#q_select_companies.contactperson#
	</td>
    <td>
		#q_select_companies.email#
	</td>
    <td>&nbsp;</td>
	<form action="act_assign_to_reseller.cfm" method="get">
	<input type="hidden" name="frmcompanykey" value="#htmleditformat(q_select_companies.entrykey)#">
    <td>
		<a href="act_set_assigned.cfm?entrykey=#urlencodedformat(q_select_companies.entrykey)#">keinem Reseller zuweisen</a>
		&nbsp;&nbsp;
	<select name="frmresellerkey">
		<cfloop query="q_Select_reseller">
		<option #writeselectedelement(q_Select_reseller.entrykey,q_select_companies.resellerkey)# value="#htmleditformat(q_Select_reseller.entrykey)#"><cfloop from="1" to="#q_select_reseller.resellerlevel#" index="ii">&nbsp;</cfloop>#htmleditformat(q_Select_reseller.companyname)#</option>
		</cfloop>
	</select>
	<br>
	Anmerkung:<br>
	<input type="text" name="frmcomment" size="30" value="">
	<input type="submit" value="Zuweisen ...">
	</td>
	</form>
  </tr>
  <tr>
  	<td colspan="7"><hr size="1" noshade></td>
  </tr>
</cfoutput>
</table>