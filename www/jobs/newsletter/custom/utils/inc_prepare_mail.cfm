<!--- //

	Module:		Newsletter/Mailing
	Description:create unique mails ... 
	

// --->

<cfsetting requesttimeout="20000">
	
<!--- load all already generated mails ... --->
<cfquery name="q_select_already_generated_mails" datasource="#request.a_str_db_crm#">
SELECT
	contactkey
FROM
	newsletter_recipients
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_profile.entrykey#">
	AND
	issuekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_nl_approved.entrykey#">
;
</cfquery>
	
<cfloop query="q_select_subscribers">

	<cfset a_tc_begin = GetTickCount() />
	<cflog text="--- next email (record no #q_select_subscribers.currentrow# / #q_select_subscribers.recordcount#) ---" type="Information" log="Application" file="ib_nl">

	<cfquery name="q_select_single_subscriber" dbtype="query">
	SELECT
		*
	FROM
		q_select_subscribers
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_subscribers.entrykey#">
	;
	</cfquery>

	<cfset sEntrykey = CreateUUID() />
	
	<cfset a_str_contactkey = '' />
	<cfset a_str_recipient = '' />
	<cfset a_str_sender = '' />
	
	<cfset a_str_html = '' />
	<cfset a_str_text = '' />
	<cfset a_str_subject = '' />
	<cfset a_str_attachments = '' />
	
	<!--- take recipient --->
	<cfset a_str_contactkey = q_select_subscribers.entrykey />
	
	<!--- already created? --->
	<cfquery name="q_select_already_generated" dbtype="query">
	SELECT
		COUNT(contactkey) as count_contact
	FROM
		q_select_already_generated_mails
	WHERE
		contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_contactkey#">
	;
	</cfquery>
	
	<cfif val(q_select_already_generated.count_contact) IS 0>
		insert.<br>
		<!--- ok, insert now! --->
		
		<cfset a_str_recipient = Trim(q_select_subscribers.firstname & ' ' & q_select_subscribers.surname & ' <' & ExtractEmailAdr(q_select_subscribers.email_prim) & '>') />

		<cflog text="to: #a_str_recipient#" type="Information" log="Application" file="ib_nl">
		
		<!--- sender --->
		<cfset a_str_sender =  Trim(q_select_profile.sender_name & ' <' & q_select_profile.sender_address & '>') />
	
		<!--- replace subject --->
		
		<cfset a_str_subject = q_select_nl_approved.subject>
		
		<!--- replace body tags ... --->
		<cfset a_str_html = q_select_nl_approved.body_html />
		<cfset a_str_text = q_select_nl_approved.body_text />	
		
		<cfset a_str_html = ReplaceNoCase(a_str_html, '<tbody>', '', 'ALL') />
		<cfset a_str_html = ReplaceNoCase(a_str_html, '</tbody>', '', 'ALL') />		
		
		<cfif FindNoCase('%', a_str_html) GT 0>
		
			<!--- replace various items .... --->			
			<cfset a_str_html = a_cmp_nl.ReplaceVariables(query_holding_data_to_replace = q_select_single_subscriber,
															query_own_datafields_crm = q_table_fields,
															entrykey = sEntrykey,
															input = a_str_html,
															usersettings = variables.stUserSettings,
															securitycontext = variables.stSecurityContext_nl,
															listkey = q_select_profile.entrykey,
															issuekey = q_select_nl_approved.entrykey,
															langno = q_select_profile.lang) />
			
			<!--- generate text version from html version --->
			<cfif q_select_nl_approved.autogenerate_text_version IS 1>
				<cfset a_str_text = StripHTML(a_str_html) />
				<cfset a_str_text = ReplaceNoCase(a_str_text, '&nbsp;', ' ', 'ALL') />
			<cfelse>
			
				<!--- manually --->
				<cfset a_str_text = a_cmp_nl.ReplaceVariables(query_holding_data_to_replace = q_select_single_subscriber,
										query_own_datafields_crm = q_table_fields,
										entrykey = sEntrykey,
										input = a_str_text,
										usersettings = variables.stUserSettings,
										securitycontext = variables.stSecurityContext_nl,
										listkey = q_select_profile.entrykey,
										issuekey = q_select_nl_approved.entrykey,
										langno = q_select_profile.lang) />
			
			</cfif>
			
		</cfif>
		
		<cfif FindNoCase('<html', a_str_html) IS 0>
			<!--- build html body ... --->		
			
			<cfsavecontent variable="a_str_html_css">
				<style type="text/css" media="all">
					/* Auto CSS */
					body, table, p, td, a, div, ul, li {
						font-family: "Lucida Grande", Arial, Verdana, Helvetica, sans-serif;
						line-height:150%;
						font-size:12px;
						}
					p {
						margin-top:4px;
						margin-bottom:0px;
						font-size:12px;
						line-height:150%;
						}
					td {
						font-size:12px;
						line-height:150%;
						}
						
					li {
						font-size:12px;
						line-height:150%;
						}
				</style>
			</cfsavecontent>
			
			<!--- set new HTML body --->
			<cfsavecontent variable="a_str_html_head">
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
			<html>
				<head>
					
				<title>Newsletter</title>
				
				<meta name="author" content="<cfoutput>#htmleditformat( variables.stSecurityContext_nl.myusername )#</cfoutput>" />
				<meta name="generator" content="openTeamWare Mailing Engine (www.openTeamWare.com)" />
				<meta name="ibx_recipient" content="<cfoutput>#htmleditformat( a_str_recipient )#</cfoutput>" />
				
			</head>
			<body>
			
			<cfoutput>#a_str_html_css#</cfoutput>
			</cfsavecontent>
			
			<cfset a_str_html = a_str_html_head & a_str_html & '</body></html>' />
			
		</cfif>
		
		<!---
			replace html links ... leave it right now
		<cfset a_str_html = ReplaceNoCase(a_str_html, '<a href="http', '<a href="http://www.openTeamWare.com/nl/c/?r=' & urlencodedformat(sEntrykey) & '&http', 'ALL')>--->
		
		
		<!--- // attachments // ... --->
		
		<!---
			save attachments ... --->
		<cfloop list="#q_select_nl_approved.attachmentkeys#" index="a_str_attachment_entrykey">
			<cfdump var="#a_str_attachment_entrykey#">
			<!--- get file, copy to a temp location and insert it into a temp location ... --->
			<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "GetFileInformation"   
				returnVariable = "a_struct_file_info"   
				entrykey = "#a_str_attachment_entrykey#"
				securitycontext="#variables.stSecurityContext_nl#"
				usersettings="#variables.stUserSettings#"
				download=false>
				
				<cfset q_query_file = a_struct_file_info.q_select_file_info />
				 
				<cfset a_str_path_attachment = q_query_file.storagepath & '/' & q_query_file.storagefilename />
				
				<!--- check if the attachment has already been loaded ... --->
				<cfset sEntrykey_attachment_file = a_cmp_nl.GetSavedAttachmentEntrykey(filekey = q_query_file.entrykey,
								issuekey = q_select_nl_approved.entrykey) />
				
				<cfif Len(sEntrykey_attachment_file) GT 0>
					already saved.			
				<cfelse>
					<!--- save to attachments table ... --->
					<cfif FileExists(a_str_path_attachment)>
						<!--- ok, save --->
						
						<cfset sEntrykey_attachment_file = a_cmp_nl.SaveAttachmentToNewsletterAttTable(filekey = q_query_file.entrykey,
								issuekey = q_select_nl_approved.entrykey,
								filename = q_query_file.filename,
								contenttype = q_query_file.contenttype,
								filename_on_disk = a_str_path_attachment) />
					</cfif>
				</cfif>
				
				<cfif FileExists(a_str_path_attachment)>
					<cfset a_str_attachments = ListAppend(a_str_attachments, sEntrykey_attachment_file)>
				</cfif>
			
	
		</cfloop>
		
		<cfset a_bol_is_test_sending = false>
		
		<cfif url.isTestSendingCall>
			<!--- we're on a test run ... --->
			<cfset a_str_recipient = q_select_profile.test_email_addresses />
			
			<!--- set a special subject --->
			<cfset a_str_subject = '[Preview] ' & a_str_subject />
			
			<!--- set test to true --->
			<cfset a_bol_is_test_sending = true />
		</cfif> 
				
		<!--- insert recipient ... --->			
		<cfset a_tmp_insert = a_cmp_nl.CreateSingleRecipientData(listkey = q_select_profile.entrykey,
																 contactkey = a_str_contactkey,
																 issuekey = q_select_nl_approved.entrykey,
																 subject = a_str_subject,
																 body_html = a_str_html,
																 body_Text = a_str_text,
																 entrykey = sEntrykey,
																 recipient = a_str_recipient,
																 attachments = a_str_attachments,
																 sender_value = a_str_sender,
																 replyto = q_select_profile.replyto,
																 test_sending = a_bol_is_test_sending)>
															 
	</cfif>
	
	<cflog text="--- email done (#(GetTickCount() - a_tc_begin)#) ---" type="Information" log="Application" file="ib_nl">	

</cfloop>

