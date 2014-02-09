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
<h4>Rechnung Nummer #q_select_bill.invoicenumber# Zahlungsziel veraendern</h4>
</cfoutput>


<cfif IsDefined('form.frm_dt_due')>


<cfset a_dt_due = LsParseDateTime(form.frm_dt_due)>

Faelligkeit wurde auf den <cfoutput>#a_dt_due#</cfoutput> geaendet.

<cfinvoke component="#request.a_str_component_billing#" method="ChangeDueDate" returnvariable="a_bol_return">
	<cfinvokeargument name="invoicekey" value="#url.entrykey#">
	<cfinvokeargument name="dt_due" value="#a_dt_due#">
</cfinvoke>

<cfelse>
<form method="post" action="act_edit_dt_due.cfm?entrykey=<cfoutput>#url.entrykey#</cfoutput>&companykey=<cfoutput>#url.companykey#</cfoutput>">
Neu: <input type="text" size="10" name="frm_dt_due" value="<cfoutput>#LsDateFormat(q_select_bill.dt_due, 'dd.mm.yy')#</cfoutput>"> dd.mm.yy

<input type="submit" value="Speichern">
</form>
</cfif>

</body>
</html>
