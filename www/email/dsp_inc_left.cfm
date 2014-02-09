<!--- //

	Module:		EMail
	Description:Left include
	

// --->

<div class="divleftnavigation_center">
	
	<div class="divleftnavpanelactions">
	<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>
		
			<ul class="divleftpanelactions">
			<li><a href="#" onClick="OpenComposePopup();return false;"><cfoutput>#GetLangVal('mail_ph_composeNewMail')#</cfoutput></a></li>
			<li><a href="default.cfm?action=ShowMailbox&Mailbox=INBOX"><cfoutput>#GetLangVal('cm_wd_inbox')#</cfoutput></a></li>
			<li><a href="default.cfm?action=folders"><cfoutput>#GetLangVal('mail_wd_folders')#</cfoutput></a></li>
			
			<cfif url.action IS 'ShowMailbox'>
			<li><a href="#" onclick="LoadFolderSmallOV();return false;"><cfoutput>#GetLangVal('mail_ph_show_folders')#</cfoutput></a></li>
			</cfif>
			
			<li><a href="default.cfm?action=filter"><cfoutput>#GetLangVal('email_wd_filter')#</cfoutput></a></li>
			<li><a href="default.cfm?action=showsearch"><cfoutput>#GetLangVal('cm_wd_search')#</cfoutput></a></li>
			<li><a href="/addressbook/"><cfoutput>#GetLangVal('cm_wd_address_book')#</cfoutput></a></li>			
			<li><a href="/settings/default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('email_ph_pop3_collector')#</cfoutput></a></li>
			<li><a href="/settings/?action=spamguard">SpamGuard</a></li>
			
			<cfif request.stSecurityContext.iscompanyadmin>
				<li><a href="/email/?action=displayusermailbox&userkey="><cfoutput>#GetLangVal('mail_ph_check_user_mails')#</cfoutput></a>
			</cfif>
			</ul>
	</div>	
	<br />
	<div class="divleftnavpanelactions">
	<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_extras')#</cfoutput></div>
		
			<ul class="divleftpanelactions">
			<li><a href="default.cfm?action=autoanswer"><cfoutput>#GetLangVal('mail_ph_autoanswer')#</cfoutput></a></li>			
			<li><a href="default.cfm?action=alerts"><cfoutput>#GetLangVal('email_wd_alerts')#</cfoutput></a></li>
			<li><a href="/mobile/"><cfoutput>#GetLangVal('email_ph_mobile_access')#</cfoutput></a></li>
			<li><a href="default.cfm?action=extras"><cfoutput>#GetLangVal('email_ph_more_Extras')#</cfoutput></a></li>
			</ul>
	</div>	
	

</div>


