<!--- //



	delete an email address

	

	check what has to be done ...

	

	// --->

	

<cfparam name="url.id" type="numeric" default="0">



<cfset SelectEmailAccountRequest.id = url.id>
<cfinclude template="queries/q_select_email_account.cfm">


<cf_disp_navigation mytextleft="E-Mail Adresse entfernen">
<br>
<!--- check what address we have got ... --->

<cfif q_select_email_account.recordcount is 0>
	<b>Diese Adresse wurde nicht gefunden.</b>
	<cfexit method="exittemplate">
</cfif>



<!---<cfdump var="#q_select_email_account#">--->


<cfif IsDefined("url.confirmed") is false>
<!--- ask for the confirmation! --->



Sind Sie sicher, dass Sie die E-Mail Adresse <cfoutput><b>#htmleditformat(q_select_email_account.emailadr)#</b></cfoutput><br>

aus Ihrem openTeamWare Onlineb&uuml;ro entfernen wollen?

<br><br>

<cfif q_select_email_account.origin is 0>

	Unter dieser E-Mail Adresse werden Sie dann keine E-Mails mehr empfangen koennen.

	<br><br>

</cfif>



<a href="index.cfm?confirmed=true&action=deleteemailaccount&id=<cfoutput>#url.id#</cfoutput>">Ja, Adresse wirklich l&ouml;schen</a>

&nbsp;&nbsp;|&nbsp;&nbsp;

<a href="index.cfm?action=emailaccounts">Nein, zur&uuml;ck zur &Uuml;bersicht</a>

<cfelse>

<!--- // delete now ... // --->

<!---

	a) from the pop3_data



	b) form the courier table if neccessary

	

	c) from forwarding ...

	

	--->

<cfset DeleteEmailAdrRequest.id = q_select_email_account.id>
<cfset DeleteEmailAdrRequest.emailadr = q_select_email_account.emailadr>

<!---<cfif q_select_email_account.origin is 0>

	<!--- an email address in the host system ... --->
	<!--- delete courier passwd record --->
	<cfinclude template="queries/q_delete_courier_record.cfm">

	<!--- delete forwarding --->

	<cfinclude template="queries/q_delete_forwarding.cfm">

</cfif>--->



<cfif q_select_email_account.origin is 1>

	<!--- delete courier email account item --->
	<cfinclude template="queries/q_delete_courier_check_item.cfm">

</cfif>

<!--- remove from pop3_data ... --->
<cfinclude template="queries/q_delete_emailadr.cfm">



<b>Die Adresse wurde erfolgreich entfernt!</b>

<br>

<br>

<a href="index.cfm?action=emailaccounts">zur&uuml;ck zur &Uuml;bersicht</a>



</cfif>