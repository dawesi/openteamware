<!--- //



	update an email account ... 

	

	// --->
<cfinclude template="../login/check_logged_in.cfm">
	
<cfparam name="form.FRMLEAVECOPY" type="numeric" default="0">
<cfparam name="form.frmcbusessl" type="numeric" default="0">
	
<cfinclude template="../common/scripts/script_utils.cfm">
<cfinclude template="queries/q_update_email_account.cfm">

<!--- do we have an external email address ? --->
<cfset SelectEmailAccountRequest.id = form.frmid>
<cfinclude template="queries/q_select_email_account.cfm">

<cfif q_select_email_account.recordcount is 0>
  <cfabort>
</cfif>

<!--- a second openTeamWare address has always to be forwarded to another (f.e. as an alias) --->
<cfif (q_select_email_account.origin is 0) AND
	  (q_select_email_account.emailadr neq request.stSecurityContext.myusername) AND
	  (len(extractemailadr(form.frmforwardingdestination)) is 0)>
  <b>Sie muessen ein Weiterleitungsziel fuer die weitere Adresse angeben!</b>	
  <br>
  <br>
  <a href="javscript:history.go(-1);">zur&uuml;ck</a> 
  <cfexit method="exittemplate">
</cfif>

<!--- update the forwarding setting ... --->
<cfif (q_select_email_account.origin is 0)>
	<!--- delete forwarding ... --->
	<cfset DeleteEmailAdrRequest.emailadr = q_select_email_account.emailadr>
	<cfinclude template="queries/q_delete_forwarding.cfm">
	
	<cfif Len(extractemailadr(form.frmforwardingdestination)) GT 0>
  		<cfinclude template="queries/q_update_forwarding.cfm">
	</cfif>
</cfif>

<cfif q_Select_email_account.origin is 0>
  <!--- write new config ... --->
  <cfmodule template="utils/mod_create_mailsystem_config.cfm"

	  	username=#q_select_email_account.emailadr#>

  <!--- update password ... maybe ;-) --->
  <cfif isDefined("form.frmpop3password") AND (Len(form.frmpop3password) gt 0)>
    <cfinclude template="queries/q_update_ib_adr_password.cfm">
  </cfif>

</cfif>

<cfif (q_select_email_account.origin is 1)>
  <!--- check autocheck ... --->
  <cfset form.frmpop3password = q_select_email_account.pop3password>
  <cfinclude template="queries/q_update_email_autocheck.cfm">
</cfif>

<cflocation addtoken="no" url="index.cfm?action=emailaccounts">
