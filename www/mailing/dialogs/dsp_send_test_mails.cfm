<!--- //

	Module:		Newsletter
	Action:		SendTestMails
	Description: 
	

// --->

<!--- issue --->
<cfparam name="url.issuekey" type="string" default="">

<!--- listkey --->
<cfparam name="url.listkey" type="string" default="">

<!--- //

	send some test emails to some email addresses
	
	in order to test if the newsletter works correctly
	
	// --->
	
<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>
<cfset q_select_profile = a_cmp_nl.GetNewsletterProfile(securitycontext = request.stSecurityContext,
							usersettings = request.stUserSettings, entrykey = url.listkey)>
	
<cfif Len(q_select_profile.test_email_addresses) IS 0>
	<!--- set test email addresses --->
	<cfquery name="q_update_test_email_addresses" datasource="#request.a_str_db_crm#">
	UPDATE
		newsletter_profiles
	SET
		test_email_addresses = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.listkey#">
		AND
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	;
	</cfquery>
</cfif>	

<!--- call the prepare script with some extra parameters ... --->
<cfset a_str_url = 'http://localhost/jobs/newsletter/custom/prepare.cfm?isTestSendingCall=true&TestSendingIssueEntrykey=' & urlencodedformat(url.issuekey) />

<cflock type="exclusive" name="lck_send_test_exemplare" timeout="600">
<cfhttp url="#a_str_url#" resolveurl="no"></cfhttp>
</cflock>

<cfoutput>#GetLangVal('nl_ph_test_run_started')#</cfoutput>



