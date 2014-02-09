<!--- //

	execute alert check
	
	// --->
<cfinclude template="/common/scripts/script_utils.cfm">

<cfquery name="q_delete_moswald" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	alerts
WHERE
	account = 'moswald@openTeamware.com'
;
</cfquery>
	
<cfquery name="q_select_open_alerts" maxrows="50" datasource="#request.a_str_db_mailusers#">
SELECT
	id,account,subject,afrom,ato,dt_insert,priority,fullheader,foldername,'' AS message_id
FROM
	alerts
ORDER BY
	id DESC
;
</cfquery>

<cfif q_select_open_alerts.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_component_im = CreateObject('component', request.a_str_component_im)>
<cfset a_bol_im_logged_in = false>

<!--- do not send alerts for "**** Spam **** messages --->
<cfoutput query="q_select_open_alerts">
<hr size="1" noshade />

<!--- extract the email address --->
<cfset a_str_account = extractemailadr(q_select_open_alerts.account)>
<h4>#htmleditformat(a_str_account)#</h4>

<!--- get full header --->
<cfset a_str_fullheader = q_select_open_alerts.fullheader>

<!--- check what's --->
<cfset a_str_hostname = request.a_str_default_mail_server>

<cfset a_str_subject = q_select_open_alerts.subject>
<cfset a_str_from = q_select_open_alerts.afrom>

<cfset a_str_messageid = ''>
<cfset a_str_references = ''>

<!--- check autoresponder ... --->
<!---Received: from mailbox.tiscali.at by localhost with POP3 (fetchmail-mypopdaemon) for request.stSecurityContext.myusername--->

<!---
Received: from mailbox.tiscali.at [212.197.128.123]
	by localhost with POP3 (fetchmail-5.9.11)
	for request.stSecurityContext.myusername (single-drop); Thu, 03 Jul 2003 14:29:34 +0200 (CEST)
--->


<!--- old: Received: from [a-z,A-Z,0-9,.,-]* \[(.*) POP3 \(fetchmail(.*)\(single-drop\); --->
<!---<cfset a_arr_ps = ReFindNoCase("Received: from [a-z,A-Z,0-9,.,-]* (.*) POP3 \(fetchmail(.*)", q_select_open_alerts.fullheader, 1, true)>--->
<cfset a_arr_ps = ReFindNoCase("Received: from [a-z,A-Z,0-9,.,-]* by localhost with POP3 \(fetchmail-mypopdaemon\)", q_select_open_alerts.fullheader, 1, true)>


<cfif a_arr_ps.pos[1] neq 0>
	<!--- get pop3 host ... and out of this information if
		autoresponders should be sent or not --->
	<cfset a_str_hostname = Mid(q_select_open_alerts.fullheader, a_arr_ps.pos[1], a_arr_ps.len[1])>
	
	<!--- get hostname ... --->
	<cfif ListLen(a_str_hostname, ' ') GT 3>
		<cfset a_str_hostname = ListGetAt(a_str_hostname, 3, ' ')>
	</cfif>
	
	<!---<cfset ii = FindNocase("[", a_str_hostname, 1)>
	
	<cfif ii gt 0>
		<cfset a_str_hostname = trim(Mid(a_str_hostname, 1, ii-1))>
		<cfset a_str_hostname = trim(Replacenocase(a_Str_hostname, "Received: from", ""))>
	</cfif>--->

</cfif>

<cfloop list="#q_select_open_alerts.fullheader#" delimiters="#chr(10)#" index="a_Str_header_line">
	<cfif FindNoCase("Subject:", a_str_header_line) is 1>
		<cfset a_str_subject = Trim(Mid(a_Str_header_line, Len('Subject: '), len(a_str_header_line)))>	
		<h1>#a_str_subject#</h1>
		
		<cfif len(a_str_subject) GT 0>
			<cfset tmp = QuerySetCell(q_select_open_alerts, 'subject', a_str_subject, q_select_open_alerts.currentrow)>
		</cfif>

	</cfif>
	
	<cfif FindNoCase('Message-ID:', a_str_header_line) IS 1>
		
		<cfset a_str_messageid = Trim(Mid(a_str_header_line, Len('Message-ID: '), len(a_str_header_line)))>	
	
		<cfset tmp = QuerySetCell(q_select_open_alerts, 'message_id', a_str_messageid, q_select_open_alerts.currentrow)>
	</cfif>
	
	<cfif FindNoCase('References:', a_str_header_line) IS 1>
		<cfset a_str_references = Trim(Mid(a_str_header_line, Len('References: '), len(a_str_header_line)))>	
	</cfif>	
	
</cfloop>

<pre>#a_str_hostname#</pre>

<cfif FindNoCase('FOUND VIRUS IN MAIL', a_str_subject) GT 0>
	<!--- update virus count ... --->
	<cfinclude template="queries/q_insert_update_virus_count.cfm">
</cfif>

<cfquery name="q_select_accountid" datasource="#request.a_str_db_users#">
SELECT
	id,userid,emailadr,userkey
FROM
	pop3_data
WHERE
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_account#">
	AND
	origin = 0
;
</cfquery>

<cfdump var="#q_select_accountid#">

<cfif (q_select_accountid.recordcount GT 0)
		AND
      (FindNoCase("X-Spam-Flag: YES", q_select_open_alerts.fullheader) GT 0)>
	<!--- spam report ... --->	  

	<h4>Spam</h4>
	<cfinclude template="queries/q_insert_update_spam_report.cfm">
</cfif>

<!--- spam? --->
<cfif (FindNoCase("**** SPAM ****", q_select_open_alerts.subject) is 0) AND
      (FindNoCase("X-Spam-Flag: YES", q_select_open_alerts.fullheader) is 0)>
	<!--- load the userid ... --->
	
	
	<cfif q_select_accountid.recordcount is 1>
	
		#a_str_account# | #htmleditformat(q_select_open_alerts.foldername)# | #htmleditformat(a_str_messageid)# |<br>
		
		<cfif Len(q_select_open_alerts.foldername) GT 0 AND Len(a_str_messageid) GT 0>
			<!--- insert lookup job ... --->
			<cfinclude template="queries/q_insert_lookup_job.cfm">
		</cfif>
		
		<cfset a_int_userid = q_select_accountid.userid>
		<cfset a_int_account_id = q_select_accountid.id>
		<cfset a_str_email_address = q_select_accountid.emailadr>
		<cfset a_str_userkey = q_select_accountid.userkey>
		
	<!--- is the user interested in alerts? --->
	<cfmodule template="/common/person/getuserpref.cfm"
		entrysection = "im"
		entryname = "enable_alerts"
		defaultvalue1 = "1"
		userid = #q_select_accountid.userid#
		setcallervariable1 = "a_int_enable_alerts">
		
	<!--- check if the user is online ... --->
	<cfset a_bol_is_online = a_str_component_im.IsUserOnline(a_str_account)>
	
	<!--- smartpush ... --->
	<!--- <cfif a_int_userid IS -2>
		<cfinclude template="queries/q_insert_smartpush_alert.cfm">
	</cfif> --->
	
	<!---<p>checking im status of <cfoutput>#a_str_account#</cfoutput>...</p>
	<p>Online: <cfoutput>#a_bol_is_online#</cfoutput></p>
	<p>a_int_enable_alerts: <cfoutput>#a_int_enable_alerts#</cfoutput></p>

	 <cfif (a_int_enable_alerts IS 1) AND a_bol_is_online>
	
		<p><b style="color:green; ">is online!</b></p>

		<!--- insert into alert table ... --->
		<cfset InsertIMAlertRequest.Recipient = a_str_account>
		<cfset InsertIMAlertRequest.Message = 'Neue Nachricht eingetroffen' & chr(13)&chr(10)&'- Betreff: ' & trim(a_str_subject)& chr(13)&chr(10)&'- Von: '&trim(a_str_from)&chr(13)&chr(10)&'- Posteingang: https://www.openTeamWare.com/rd/email/inbox/'>

		<cfinclude template="queries/q_insert_im_alert.cfm">
	

	</cfif> --->

		<!--- insert into the reminder alert table ... --->
		<cfmodule template="mod_insert_reminder.cfm"
			userid = #a_int_userid#
			lastfrom = #a_str_from#
			lastsubject = #a_str_subject#>
		
		<!--- what's if we've an external email addres ... --->
		<cfif (q_select_accountid.recordcount is 1) AND (CompareNocase(a_str_hostname, request.a_str_default_mail_server) neq 0)>
			<!--- select the id ... hostname ... --->
			
			<cfquery name="q_select_emailadr" datasource="#request.a_str_db_users#">
			SELECT
				id,emailadr
			FROM
				pop3_data
			WHERE
				userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">
				AND
				pop3server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_hostname#">
			;
			</cfquery>
			
			<cfset a_int_account_id = q_select_emailadr.id>
			<cfset a_str_email_address = q_select_emailadr.emailadr>	
		
		</cfif>
		
		
		<!--- check autoresponder --->
		<cfquery name="q_select_account" datasource="#request.a_str_db_users#">
		SELECT
			AwayMsg,SendAwayMsg
		FROM
			pop3_data
		WHERE
			id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_account_id)#">
			AND
			userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">
		;
		</cfquery>
		
		<cfif (Len(q_select_account.awaymsg) gt 0) AND (q_select_account.SendAwaymsg is 1)>
		
				<!--- check if we've sent too many alerts ... --->
				<cfquery name="q_select_autoresponder_count" datasource="#request.a_str_db_mailusers#">
				SELECT
					sentcount
				FROM
					autoresponderscount 
				WHERE
					email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_email_address#">
					AND
					recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_from#">
				;
				</cfquery>
				
				<cfif (q_select_autoresponder_count.recordcount is 0 OR q_select_autoresponder_count.sentcount lt 5)>
					<!--- send automatic response --->
					<cfset a_int_autoresponder_sentcount = val(q_select_autoresponder_count.sentcount)+1>
					
					<!--- delete and re-insert ... --->
					<cfquery name="q_delete_autoresponder_count" datasource="#request.a_str_db_mailusers#">
					DELETE FROM
						autoresponderscount
					WHERE
						email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(a_str_email_address, 1, 250)#">
						AND
						recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(a_str_from, 1, 250)#">
					;
					</cfquery>
					
					<cfquery name="q_delete_autoresponder_count" datasource="#request.a_str_db_mailusers#">
					INSERT INTO autoresponderscount
					(email,recipient,sentcount)
					VALUES
					(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(a_str_email_address, 1, 250)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(a_str_from, 1, 250)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_autoresponder_sentcount#">);
					</cfquery>
					
					<!--- send now ... --->
					<cfmodule template="mod_send_autoresponse.cfm"		
						awaymsg=#q_select_account.awaymsg#
						recipient=#a_str_from#
						username=#a_str_account#
						afrom=#a_str_email_address#>
						
				</cfif>
		</cfif>
		
		<!--- check now the reminders and alerts ... --->
		<cfquery name="q_select_alert_settings" datasource="#request.a_str_db_users#">
		SELECT
			nonightalerts,type,maxperday,donetoday,excludeadr,enabled,emailaddress,userid
		FROM
			newmailalerts
		WHERE
			accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_account_id)#">
			AND
			userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">
		;
		</cfquery>
		
		<!--- <cfdump var="#q_select_alert_settings#" label="q_select_alert_settings"> --->
		
		<cfquery name="q_select_email_remind" debug="yes" dbtype="query">
		SELECT emailaddress FROM q_select_alert_settings
		WHERE type = 30;
		</cfquery>
		
		<cfif q_select_email_remind.recordcount is 1>
			<!--- send out an email alert ... --->
			<cfmodule template="mod_send_email_alert.cfm"
					recipient = #q_select_email_remind.emailaddress#
					userid = #q_select_alert_settings.userid#
					subject = #a_str_subject#
					afrom = #a_str_from#
					account = #a_str_email_address#>
		</cfif>
		
		<cfquery name="q_select_sms_alert" debug="yes" dbtype="query">
		SELECT
			donetoday,maxperday,excludeadr
		FROM
			q_select_alert_settings
		WHERE
			(type = 10)
			AND
			(donetoday < maxperday)
			
			<cfif val(q_select_alert_settings.nonightalerts) IS 1>
				<!--- no night alerts ... --->
				<cfif (Hour(Now()) LT 8) OR (Hour(Now()) GTE 22)>
				AND
				(1 = 0)
				</cfif>
			</cfif>
		;
		</cfquery>
		
		<!--- <cfdump var="#q_select_sms_alert#" label="q_select_sms_alert"> --->
		
		<cfif q_select_sms_alert.recordcount is 1>
			<!--- sms alert ... --->
			
			<!--- check if not an exclude address --->
			<cfset a_str_exclude_address = ReplaceNoCase(q_select_sms_alert.excludeadr, chr(13)&chr(10), "", "ALL")>
			
			
			<!--- exclude exclusions and some other addresses ... --->			
			<!--- (ListContainsNoCase(a_str_exclude_address, a_str_from, chr(13)&chr(10)) is 0) --->
			<cfif (FindNoCase(a_str_from, a_str_exclude_address) is 0) AND
				  (FindNoCase(ExtractEmailAdr(a_str_from), a_str_exclude_address) is 0) AND
			 	  (comparenocase(a_str_account, extractemailadr(a_str_from)) neq 0) AND
				  (FindNoCase("X-openTeamWare-Notify: None", a_str_fullheader) is 0) AND
				  (FindNoCase("Precedence: bulk", a_str_fullheader) is 0)>
			
				<!--- we're alright ... --->
				<cfquery name="q_select_mobile_nr" datasource="#request.a_str_db_users#" dbtype="ODBC">
				SELECT mobilenr FROM users WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_alert_settings.userid#">;
				</cfquery>
				
				<cfset a_str_mobile_nr = BeautifyNumber(q_select_mobile_nr.mobilenr)>
				
				<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_sc">
					<cfinvokeargument name="userkey" value="#q_select_accountid.userkey#">
				</cfinvoke>
				
				
				<cfset a_str_msg = "Alert: Neue E-Mail von "&mid(trim(a_str_from), 1, 50)&"; Betreff >"&Mid(trim(a_str_subject), 1, 40)&"< - Ihr openTeamWare Buddy">
				
				<cfinvoke component="/components/mobile/cmp_sms" method="SendSMSEx" returnvariable="stReturn_sms_send">
					<cfinvokeargument name="securitycontext" value="#variables.stReturn_sc#">
					<cfinvokeargument name="body" value="#a_str_msg#">
					<cfinvokeargument name="sender" value="openTeamWare">
					<cfinvokeargument name="recipient" value="#a_str_mobile_nr#">
					<cfinvokeargument name="dt_send" value="#Now()#">
				</cfinvoke> 
				

				<!--- update ... one more sent today ... --->
				<cfquery name="q_update_sms_donetoday" datasource="#request.a_str_db_users#">
				UPDATE newmailalerts
				SET donetoday = donetoday + 1
				WHERE accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_account_id)#">
				AND userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">;
				</cfquery>
			
			<cfelse>
			ignore
			</cfif>
	
		</cfif><!--- // end of "account exists" // --->
	</cfif>

</cfif>

<!--- delete entry now --->
<cfquery name="q_delete_open_alert" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	alerts
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_open_alerts.id#">
;
</cfquery>

</cfoutput>