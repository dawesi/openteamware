<!--- //

	handle bounces
	
	// --->
<cfinclude template="/common/scripts/script_utils.cfm">
	
<cfset a_str_userkey_bounce_return = '22C978D6-0C89-ED85-0D0162BCEF89F017'>

<cfset a_str_ids_2_delete = ''>

<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
	<cfinvokeargument name="userkey" value="#a_str_userkey_bounce_return#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_str_userkey_bounce_return#">
</cfinvoke>

<cfset CheckBounces.stSecurityContext = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_str_userkey_bounce_return#">
</cfinvoke>

<cfset CheckBounces.stUserSettings = a_struct_settings>


<cfinvoke component="#application.components.cmp_email#"
	method="ListMessages"
	returnvariable="a_return_struct">
	<cfinvokeargument name="accessdata" value="#a_struct_imap_access_data#">
	<cfinvokeargument name="foldername" value="INBOX">
	<cfinvokeargument name="beautifyfromto" value="false">
	<cfinvokeargument name="loadpreview" value="0">
</cfinvoke>

<cfset q_select_mailbox = a_return_struct["query"]>

<cfquery name="q_select_bounces" dbtype="query" maxrows="35">
SELECT
	afrom,ato,subject,id
FROM
	q_select_mailbox
ORDER BY
	id DESC
;
</cfquery>

<cfdump var="#q_select_bounces#">

<cfoutput query="q_select_bounces">

	<cfset a_str_id = q_select_bounces.id>
	<cfset a_str_from = q_select_bounces.afrom>
	<cfset a_str_subject = q_select_bounces.subject>
	<cfset a_str_to = ExtractEmailAdr(q_select_bounces.ato)>
	<cfset sEntrykey = ''>
	
	<cfif FindNoCase('@', a_str_to) GT 0>
		<cfset sEntrykey = Mid(a_str_to, 1, (FindNoCase('@', a_str_to)-1))>
	</cfif>
	
	<!--- // check sender and subject ... // --->
	<cfset a_bol_bounce = ((FindNoCase('delivery failed', a_str_subject) GT 0) OR
							(FindNoCase('mailer-daemon@', a_str_from) GT 0) OR
							(FindNoCase('postmaster@', a_str_from) GT 0))>
	
	<cfif a_bol_bounce>
	
		<!--- get address --->
		<cfquery name="q_select_nl_recipient" datasource="#request.a_str_db_crm#">
		SELECT
			recipient,issuekey,listkey
		FROM
			newsletter_recipients
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
		;
		</cfquery>	
		
		<!--- if user is still in database, add bounce history and set bounced = 1 --->
		<cfif q_select_nl_recipient.recordcount IS 1>
		
			<!--- Update: bounced --->
			<cfquery name="q_update_set_bounces" datasource="#request.a_str_db_crm#">
			UPDATE
				newsletter_recipients
			SET
				bounced = 1
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
			;
			</cfquery>
			
			<cfquery name="q_insert_bounce_history" datasource="#request.a_str_db_crm#">
			INSERT INTO
				bounce_history
				(
				email_adr,
				dt_created,
				issuekey,
				listkey
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_nl_recipient.recipient#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_nl_recipient.issuekey#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_nl_recipient.listkey#">
				)
			;
			</cfquery>
		
		</cfif>
	
	</cfif>
	
	<!--- delete this msg from INBOX --->
	<cfset a_str_ids_2_delete = ListAppend(a_str_ids_2_delete, a_str_id)>

</cfoutput>

<cfif Len(a_str_ids_2_delete) GT 0>
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#a_struct_imap_access_data.a_str_imap_host#">
		<cfinvokeargument name="username" value="#a_struct_imap_access_data.a_str_imap_username#">
		<cfinvokeargument name="password" value="#a_struct_imap_access_data.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="INBOX">
		<cfinvokeargument name="uids" value="#a_str_ids_2_delete#">
	</cfinvoke>		
</cfif>