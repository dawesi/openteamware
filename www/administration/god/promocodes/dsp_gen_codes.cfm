
<cfquery name="q_select_reseller" dbtype="query">
SELECT
	*
FROM
	request.q_Select_reseller
WHERE
	contractingparty = 1
;
</cfquery>

<b>Codes generieren</b>
<form action="act_gen_codes.cfm" method="post">

<!--- select reseller --->
Reseller: <select name="frmresellerkey">
<cfoutput query="q_select_reseller">
	<option value="#q_select_reseller.entrykey#">#q_select_reseller.companyname#</option>
</cfoutput>
</select>
<br><br>
Start: <input type="text" name="frmstart" value="" size="6">
<br>
Ende: <input type="text" name="frmend" value="" size="6">
<br><br>
Value: <input type="text" name="frmvalue" value="5">
<br><br>
<input type="submit" value="Erstellen ...">
</form>