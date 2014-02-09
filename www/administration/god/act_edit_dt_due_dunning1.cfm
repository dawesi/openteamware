<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#request.a_str_component_billing#" method="GetBill" returnvariable="q_select_bill">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfoutput>
<h4>Rechnung Nummer #q_select_bill.invoicenumber# Mahnungsziel veraendern</h4>
</cfoutput>


<cfif IsDefined('form.frm_dt_dunning1')>


<cfset a_dt_dunning1 = LsParseDateTime(form.frm_dt_dunning1)>

Erstellungsdatum der ersten Mahnung wurde auf den <cfoutput>#a_dt_dunning1#</cfoutput> geaendet.

<cfinvoke component="#request.a_str_component_billing#" method="ChangeCreationDateOfFirstDunningLetter" returnvariable="a_bol_return">
	<cfinvokeargument name="invoicekey" value="#url.entrykey#">
	<cfinvokeargument name="dt" value="#a_dt_dunning1#">
</cfinvoke>

<cfelse>
<form method="post" action="act_edit_dt_due_dunning1.cfm?entrykey=<cfoutput>#url.entrykey#</cfoutput>&companykey=<cfoutput>#url.companykey#</cfoutput>">
1. Mahnung wurde erstellt am: <input type="text" size="10" name="frm_dt_dunning1" value="<cfoutput>#LsDateFormat(q_select_bill.dt_dunning1, 'dd.mm.yy')#</cfoutput>"> dd.mm.yy

<input type="submit" value="Speichern">
<br><br>
2. Mahnung erfolgt 6 Tage spaeter
</form>
</cfif>

</body>
</html>
