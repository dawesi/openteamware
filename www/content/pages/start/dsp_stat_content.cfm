<cfquery name="q_select_lastsync" datasource="#request.a_str_db_tools#">
SELECT
	dt_lastmodified,install_name
FROM
	install_names 
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
ORDER BY
	dt_lastmodified DESC
;
</cfquery>

<cfset variables.a_cmp_email_accounts = CreateObject('component', '/components/email/cmp_accounts')>

<cfinvoke component="#application.components.cmp_email_tools#" method="GetQuotaDataForUser" returnvariable="a_struct_quota">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<cfinvoke component="#variables.a_cmp_email_accounts#" method="GetEmailAccounts" returnvariable="q_select_email_addresses">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="#variables.a_cmp_email_accounts#" method="GetSpamassassinSettings" returnvariable="q_select_spamguard_settings">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<cfquery name="q_select_email_addresses" dbtype="query">
SELECT
	*
FROM
	q_select_email_addresses
WHERE
	origin = 1
;
</cfquery>

<cfinvoke component="#request.a_str_component_mobilesync#" method="GetDevicesOfUser" returnvariable="q_select_devices">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>


<fieldset class="bg_fieldset">
	<legend>
		<a href="/settings/"><img align="absmiddle" src="/images/icon/img_stat_32x32.gif" width="32" height="32" hspace="2" vspace="2" border="0"> <cfoutput>#GetLangVal('start_ph_statistics_settings')#</cfoutput></a>
	</legend>

	<div class="div_startpage_contentbox_content">
	
		<table border="0" cellspacing="0" cellpadding="3" width="100%">
			<tr>
				<td width="35"><img src="/images/space_1_1.gif"></td>
				<td colspan="3"><img src="/images/space_1_1.gif"></td>
			</tr>
		  <tr>
		  	<td colspan="2" class="bb addinfotext">
				<img src="/images/settings/menu_emailadressen_grayscal.gif" width="19" border="0" height="19" alt="E-Mail" align="absmiddle"> <a href="/settings/?action=emailaccounts" class="addinfotext"><cfoutput>#GetLangVal('cm_ph_linked_email_addresses')#</cfoutput> (<cfoutput>#q_select_email_addresses.recordcount#</cfoutput>)</a>
			</td>
			<td colspan="2" class="bb addinfotext">
				<cfoutput>#GetLangVal('stat_ph_last_check')#</cfoutput>
			</td>
		  </tr>
		  <cfoutput query="q_select_email_addresses">
		  <tr>
			<td width="35" align="center">
				<img src="/images/space_1_1.gif">
			</td>
			<td>
				<a href="/email/?action=pop3check">#htmleditformat(q_select_email_addresses.emailadr)#</a>
			</td>
			<td>
			
					<cfquery name="q_select_fetchmail_logbook" datasource="#request.a_str_db_mailusers#">
					SELECT
						dt_check,emailadr,exitcode
					FROM
						fetchmailexitcodes
					WHERE
						(account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
						AND
						(emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_email_addresses.pop3username#@#q_select_email_addresses.pop3server#">)
					ORDER BY
						dt_check DESC
					LIMIT 1
					;
					</cfquery>
							
					#DateFormat(q_select_fetchmail_logbook.dt_check, request.stUserSettings.default_dateformat)# #TimeFormat(q_select_fetchmail_logbook.dt_check, request.stUserSettings.default_timeformat)#

			</td>
			<td>&nbsp;</td>
		  </tr>
		  </cfoutput>
		  <tr>
		  	<td></td>
			<td colspan="3">
				<a href="/settings/default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('start_ph_include_further_email_address')#</cfoutput> ...</a>
			</td>
		  </tr>
		  <tr>
		  	<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">
				<a href="/download/" class="addinfotext"><img src="/images/settings/img_outlook_grayscale_19x19.gif" width="19" height="19" border="0" alt="Outlook" align="absmiddle"> OutlookSync (<cfoutput>#q_select_lastsync.recordcount#</cfoutput>)</a>
			</td>
			<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">
				<cfoutput>#GetLangVal('cm_ph_lastsync')#</cfoutput>
			</td>
		  </tr>		
		  <cfoutput query="q_select_lastsync">
		  <tr>
		  	<td width="35" align="center">
				<img src="/images/space_1_1.gif">
			</td>
			<td>
				#htmleditformat(q_select_lastsync.install_name)#
			</td>
			<td>
				#LSDateFormat(q_select_lastsync.dt_lastmodified, 'dd.mm.yy')# #TimeFormat(q_select_lastsync.dt_lastmodified, 'HH:mm')#			
			</td>
			<td>&nbsp;</td>
		  </tr>		  
		  </cfoutput> 
		  <tr>
		  	<td></td>
			<td colspan="3">
				<a href="/download/"><cfoutput>#GetLangVal('start_ph_download_outlooksync_now')#</cfoutput> ...</a>
			</td>
		  </tr>
		  <tr>
		  	<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">
				<img src="/images/settings/img_sync_grayscale_19x19.gif" align="absmiddle" border="0" width="19"> <a href="/synccenter/" class="addinfotext">SyncCenter (<cfoutput>#q_select_devices.recordcount#</cfoutput>)</a>
			</td>
				<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">
					<cfif q_select_devices.recordcount GT 0>
						<cfoutput>#GetLangVal('cm_ph_lastsync')#</cfoutput>
					<cfelse>
						<a href="/synccenter/default.cfm?action=addmobilesyncdevice"><cfoutput>#GetLangVal('sync_ph_add_new_device')#</cfoutput> ...</a>
					</cfif>
				</td>
			  </tr>	
			  <cfoutput query="q_select_devices">
				<tr>
					<td width="35" align="center">
						<img src="/images/space_1_1.gif">
					</td>
					<td>
						#htmleditformat(q_select_devices.type)#
					</td>
					<td>
						<cfif IsDate(q_select_devices.dt_lastsync)>
							#DateFormat(q_select_devices.dt_lastsync, request.stUserSettings.default_dateformat)# #TimeFormat(q_select_devices.dt_lastsync, request.stUserSettings.default_timeformat)#
						</cfif>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			  </cfoutput>	
		  
		  <cfif q_select_devices.recordcount GT 0>
		  <tr>
		  	<td></td>
			<td colspan="3">
				<a href="/synccenter/default.cfm?action=addmobilesyncdevice"><cfoutput>#GetLangVal('sync_ph_add_new_device')#</cfoutput> ...</a>
			</td>
		  </tr>
		  </cfif>
		  <tr>
		  	<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">
				<img src="/images/space_1_1.gif" width="19" height="19" align="absmiddle"> <cfoutput>#GetLangVal('adm_wd_statistics')#</cfoutput>
			</td>
			<td colspan="2" class="bb addinfotext" style="padding-top:20px; ">&nbsp;
				
			</td>
		  </tr>	
		  <tr>
		  	<td>&nbsp;</td>
			<td valign="top"  style="padding-top:10px; ">
				<cfoutput>#GetLangVal('stat_ph_mailbox_usage')#</cfoutput> (<cfoutput>#byteConvert(a_struct_quota.currentsize)#/#byteConvert(a_struct_quota.maxsize)#</cfoutput>)		
			</td>
			<td valign="top" style="padding-top:10px; ">
				<cfset a_int_one_percent = a_struct_quota.maxsize / 100>
				<cftry>
				
				<cfset a_int_percent = Int(val(a_struct_quota.currentsize / a_int_one_percent))>
				
				<div style="width:100px;height:14px;padding:0px;" class="b_all">
					<div class="br" style="height:14px;padding:0px;background-color:<cfif a_int_percent GTE 70>red<cfelse>silver</cfif>;width:<cfoutput>#a_int_percent#</cfoutput>px;">
					<img src="/images/space_1_1.gif" width="1" height="1" border="0">
					</div>	
				</div>
				
				<cfcatch type="any">
				</cfcatch></cftry>
			</td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
			<td>			
				<cfoutput>#GetLangVal('stat_ph_virus_and_spam_protection')#</cfoutput>			
			</td>
			<td>
				<font style="color:green;font-weight:bold; "><cfoutput>#GetLangVal('stat_wd_activated')#</cfoutput></font> [<a href="/settings/default.cfm?action=spamguard"><cfoutput>#GetLangVal('cm_wd_settings')#</cfoutput></a>]
			</td>
		  </tr>
		</table>
		
	

	</div>

</fieldset>