<!--- //

	Module:		Admin/God
	Description:Overview
	
// --->

<cfparam name="url.action" type="string" default="">

<html>
<head>
<title>Administration ... god mode</title>

<cfinclude template="/style_sheet.cfm">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<h2>Administration (<cfoutput>#si_img('user')# #session.stSecurityContext.myusername#</cfoutput>)</h2>
<a href="logout.cfm"><cfoutput>#si_img('cross')#</cfoutput>Logout</a>
<br /><br />  
&nbsp;
<a href="index.cfm">Home</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=assigntoreseller">Assign to Reseller</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=prices">Preise</a>
&nbsp;|&nbsp;
<a href="reseller/">Reseller-Verwaltung</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=changaccountcompany">Kontozuordnung</a>
&nbsp;|&nbsp;
<a href="?action=invoices">Rechnungen</a>
&nbsp;|&nbsp;
<a href="?action=disablecustomer">Kunden sperren</a>
&nbsp;|&nbsp;
<a href="?action=settrialend">Testende bearbeiten</a>
&nbsp;|&nbsp;
<a href="stat/">Statistik</a>
&nbsp;|&nbsp;
<a href="registrationblacklist/">Registration-Blacklist</a>
&nbsp;|&nbsp;
<a href="trialtocustomer/">Trial To Customer</a>
&nbsp;|&nbsp;
<a href="bonuspoints/">Bonuspunkte</a>
&nbsp;|&nbsp;
<a href="promocodes/">Promocodes</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=createinvoice">Manuelle Rechnung</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=renameuser">Rename user</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=editlicencestatus">Edit licence status</a>
&nbsp;|&nbsp;
<a href="index.cfm?action=copynlsubscribers">Copy newsletter subscribers</a>

<hr>

<cfswitch expression="#url.action#">
	<cfcase value="prices">
	<cfinclude template="dsp_prices.cfm">
	</cfcase>
	
	<cfcase value="changaccountcompany">
	<cfinclude template="dsp_changaccountcompany.cfm">
	</cfcase>
	
	<cfcase value="copynlsubscribers">
	<cfinclude template="dsp_copynlsubscribers.cfm">
	</cfcase>
	
	<cfcase value="adddomain">
	<cfinclude template="dsp_add_domain.cfm">
	</cfcase>
	
	<cfcase value="invoices">
	<cfinclude template="dsp_invoices.cfm">
	</cfcase>
	
	<cfcase value="assigntoreseller">
	<cfinclude template="dsp_assign_to_reseller.cfm">
	</cfcase>
	
	<cfcase value="disablecustomer">
	<cfinclude template="dsp_disable_customer.cfm">
	</cfcase>
	
	<cfcase value="setinvoicepaid">
	<cfinclude template="dsp_set_invoice_paid.cfm">
	</cfcase>
	
	<cfcase value="settrialend">
	<cfinclude template="dsp_settrialend.cfm">
	</cfcase>
	
	<cfcase value="editinvoice">
	<cfinclude template="dsp_edit_invoice.cfm">
	</cfcase>
	
	<cfcase value="createinvoice">
	<cfinclude template="dsp_create_invoice.cfm">
	</cfcase>
	
	<cfcase value="renameuser">
		<cfinclude template="dsp_renameuser.cfm">
	</cfcase>
	
	<cfcase value="editlicencestatus">
		<cfinclude template="licence/dsp_welcome.cfm">
	</cfcase>

</cfswitch>

</body>
</html>



