<!--- //

	Module:		Mailing/Newsletter
	Description: 
	
// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="MakeProfileInvisible" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of list">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfinclude template="queries/q_update_profile_set_inivisible.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="LoadIgnoreList" output="false" returntype="query" hint="load items to ignore (people who have unsubscribed)">
		<cfargument name="listkey" type="string" required="yes" hint="entrykey of list">
		
		<cfinclude template="queries/q_select_ignore_list_for_list.cfm">
		
		<cfreturn q_select_ignore_list_for_list>
	</cffunction>

	<cffunction access="public" name="DeleteIgnoreItem" output="false" returntype="boolean">
		<cfargument name="listkey" type="string" required="yes" hint="entrykey of list">
		<cfargument name="contactkey" type="string" required="yes" hint="entrykey of ignore item">

		<cfinclude template="queries/q_delete_ignore_item.cfm">
	
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteWaitingIssue" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfinclude template="queries/q_delete_waiting_issue.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="SubscribeUser" output="false" returntype="struct" hint="subscribe someone">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="contactkey" type="string" required="no" default="" hint="entrykey of contact">
		<cfargument name="emailaddress" type="string" required="no" default="" hint="email address (if email only list)">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfset var sEntrykey = CreateUUID()>
		<cfset var stReturn = StructNew()>
		<cfset var q_select_profile = 0 />
		
		<cfset stReturn.error = 99>
		<cfset stReturn.errormessage = ''>
		
		<cfset q_select_profile = GetNewsletterprofile(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.listkey)>
		
		<!--- do not allow crm filter lists --->
		<cfif val(q_select_profile.listtype) IS 0>
			<cfset stReturn.errormessage = 'Not allowed to add members to a crm filter based list.'>
			<cfreturn stReturn>
		</cfif>
		
		<cfif q_select_profile.listtype IS 2>
			<!--- use contactkey --->
			<cfif Len(arguments.contactkey) IS 0>
				<cfset stReturn.errormessage = 'contactkey length is zero'>
				<cfreturn stReturn>
			</cfif>
			
			<cfinclude template="queries/q_insert_subscriber_addressbook.cfm">
		</cfif>
		
		<cfif q_select_profile.listtype IS 1>
			<!--- email only --->
		</cfif>
		
		<cfset stReturn.error = 0>
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="CreateAddressbookIgnoreItem" output="false" returntype="boolean" hint="exclude someone ...">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="emailadr" type="string" required="yes">
		
		<cfinclude template="queries/q_insert_ignore_addressbook_item_2.cfm">	
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="UnsubscribeUser" output="false" returntype="struct" hint="exclude someone">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="recipientkey" type="string" required="yes" hint="give the recipientkey ...">
		
		<cfset var stReturn = StructNew()>
		<cfset stReturn.result = false>
		
		<!--- already on ignore list? --->
		
		<!--- select property --->
		<cfinclude template="queries/q_select_recipient.cfm">
		
		<cfif q_select_recipient.recordcount NEQ 1>
			<cfreturn stReturn>
		</cfif>
		
		<cfset stReturn.result = true>
		
		<cfswitch expression="#q_select_recipient.recipient_source#">
			<cfcase value="1">
				<!--- simple email address --->
			</cfcase>
			<cfdefaultcase>
				<!--- item from address book ... therefore add contactkey to ignore list --->
				<cfinclude template="queries/q_insert_ignore_addressbook_item.cfm">				
			</cfdefaultcase>
		</cfswitch>
		
		<cfset stReturn.q_select_recipient = q_select_recipient>
		
		<cfreturn stReturn>		
	</cffunction>
	
	<cffunction access="public" name="CreateIgnoreItem" output="false" returntype="boolean">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="contactkey" type="string" required="yes">
		<cfargument name="emailadr" type="string" required="yes">
		<cfargument name="contacttype" type="numeric" default="0" required="yes">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetNewsletterAttachmentProperties" output="false" returntype="struct" hint="get properties of a stored newsletter attachment">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of newsletter attachment">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_str_tmp_directory = request.a_str_temp_directory_local & createUUID() & request.a_str_dir_separator />
		<cfset var a_str_check_filename = '' />
		<cfset var a_str_tmp_filename = '' />
		<cfset var a_str_bin_content = 0 />
		
		<!--- create the tmp directory --->
		<cfdirectory directory="#a_str_tmp_directory#" action="create">
		
		<!--- load properties ... --->
		<cfinclude template="queries/q_select_newsletter_attachment.cfm">
		
		<cfset a_str_check_filename = ReplaceNoCase(q_select_newsletter_attachment.filename, ' ', '_', 'ALL') />
		<cfset a_str_check_filename = ReReplaceNoCase(a_str_check_filename, '[^a-z,0-9,.,_,\-,]*', '', 'ALL') />
		
		<cfif Len(a_str_check_filename) GT 0>
			<!--- use temp file dir + filename --->
			<!--- '_' & a_str_check_filename --->
			<cfset a_str_tmp_filename = a_str_tmp_directory & 'Attachment-' & RandRange(1, 9999) & '.' & ListLast(a_str_check_filename, '.') />
			<cfset a_str_tmp_filename = a_str_tmp_directory & a_str_check_filename />
			<!---<cfset a_str_tmp_filename = a_str_tmp_directory &  & '.pdf'>--->
		<cfelse>
			<!--- invalid filename, auto-generate filename ... --->
			<cfset a_str_tmp_filename = a_str_tmp_directory & CreateUUID() />
		</cfif>
		
		<cfset stReturn.filename = q_select_newsletter_attachment.filename />
		<cfset stReturn.contenttype = q_select_newsletter_attachment.contenttype />
		
		<cfset a_str_bin_content = ToBinary(q_select_newsletter_attachment.filecontent) />
		
		<cffile action="write" addnewline="no" file="#a_str_tmp_filename#" output="#a_str_bin_content#">
		
		<cfset stReturn.filename_on_disk = a_str_tmp_filename />
		
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="SaveAttachmentToNewsletterAttTable" output="false" returntype="string">
		<cfargument name="filekey" type="string" required="yes" hint="entrykey of storage item">
		<cfargument name="issuekey" type="string" required="yes" hint="entrykey of issue">
		<cfargument name="filename" type="string" required="yes">
		<cfargument name="contenttype" type="string" required="yes">
		<cfargument name="filename_on_disk" type="string" required="yes">
		
		<cfset var sReturn = CreateUUID()>
		
		<cfinclude template="queries/q_insert_newsletter_attachment.cfm">
		
		<cfreturn sReturn>
	</cffunction>
	
	<cffunction access="public" name="GetSavedAttachmentEntrykey" returntype="string" output="false" hint="check if a certain file has already been saved">
		<cfargument name="filekey" type="string" required="yes" hint="entrykey of storage item">
		<cfargument name="issuekey" type="string" required="yes" hint="entrykey of issue">
		
		<cfinclude template="queries/q_select_file_att_entrykey.cfm">
		
		<cfreturn q_select_file_att_entrykey.entrykey>
	</cffunction>
	
	<cffunction access="public" name="GetSubscribers" output="false" returntype="query" hint="return list of subscribers (query)">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">		
		<cfargument name="listkey" type="string" required="yes" hint="entrykey of list">
		<cfargument name="options" type="string" default="" required="no" hint="various options">
		<cfargument name="maxnumber" type="numeric" default="0" required="no" hint="max number of contacts to return (default = 0 = all)">
		<cfargument name="testrun" type="boolean" default="false" required="false" hint="is it a testrun?">
		
		<!--- check list type ... load crm data or simple email list --->
		<cfset var q_select_subscribers = 0 />
		<cfset var q_select_ignored = 0 />
		<cfset var q_select_profile = GetNewsletterprofile(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.listkey)>
		<cfset var a_struct_crm_filter = StructNew() />
		<cfset var a_struct_loadoptions = StructNew() />
		<cfset var a_struct_load_contacts = StructNew() />
		<cfset var q_select_subscribers_entrykeys = 0 />
		<cfset var a_struct_subscribers_entrykeys = StructNew() />
		<cfset var tmp = false />

		<!--- remote ignore list --->
		<cfif ListFindNoCase(arguments.options, 'donotremoveignoreitems') IS 0>
			<cfset q_select_ignored = LoadIgnoreList(listkey = arguments.listkey)>
		</cfif>
		
		<!--- which type ... --->
		<cfswitch expression="#q_select_profile.listtype#">
			<cfcase value="2">
				<!--- subscribers are entrykey of contacts --->
				<cfinclude template="utils/inc_load_subscribers_using_entrykeys.cfm">
				
				<cfreturn q_select_subscribers />
			</cfcase>
			<cfcase value="1">
				<!--- static ... just a list of email addresses --->
				<cfinclude template="utils/inc_load_subscribers_email_only.cfm">
				
				<cfreturn q_select_subscribers />
			</cfcase>
			<cfcase value="0">
				<!--- using a crm filter --->
				<cfinclude template="utils/inc_load_subscribers_using_crmfilter.cfm">
				
				<cfreturn q_select_subscribers />
			</cfcase>
		</cfswitch>


		
	</cffunction>
	
	<cffunction access="public" name="CreateSingleRecipientData" returntype="boolean"
			hint="Insert a single recipient data">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="issuekey" type="string" required="yes">
		<cfargument name="contactkey" type="string" required="no" default="" hint="entrykey of contact (if possible)">
		<cfargument name="type" type="numeric" default="0" required="false"
			hint="type of recipient ... 0 = email (default), 1 = fax, 2 = sms">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="body_html" type="string" required="yes">
		<cfargument name="body_text" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="recipient" type="string" required="yes">
		<cfargument name="attachments" type="string" required="no" default="" hint="list of attachments (one per line)">
		<cfargument name="sender_value" type="string" required="yes" hint="full from header">
		<cfargument name="replyto" type="string" required="no" default="" hint="reply to address">
		<cfargument name="test_sending" type="boolean" default="false" required="no" hint="if true, delete after sending so that the mails get prepared again">
		
		<cfset var a_int_test_sending = 0 />
		<cfset var q_insert_recipient = 0 />
		<cfset var a_str_email_adr = ExtractEmailAdr(arguments.recipient) />
		
		<cfif arguments.test_sending>
			<cfset a_int_test_sending = 1>
		</cfif>
		
		<cfinclude template="queries/q_insert_recipient.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetIssue" output="false" returntype="query" hint="return a single issue">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfreturn GetIssues(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykeys = arguments.entrykey) />
	</cffunction>
	
	<cffunction access="public" name="GetIssues" output="false" returntype="query" hint="return issues">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<!--- filters --->
		<cfargument name="filter_listkey" type="string" required="no" default="">
		<cfargument name="filter_approved" type="numeric" required="no" default="-1">
		<cfargument name="entrykeys" type="string" required="no" default="" hint="list of entrykeys to filter">
		
		<cfset q_select_issues = 0 />
		
		<cfinclude template="queries/q_select_issues.cfm">
		
		<cfreturn q_select_issues />
	
	</cffunction>
	
	<cffunction access="public" name="ApproveIssue" output="false" returntype="boolean" hint="approve sending of issue">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="issuekey" type="string" required="yes" hint="entrykey of issue">
		
		<cfinclude template="queries/q_update_set_approved.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="SaveOrUpdateIssue" output="false" returntype="boolean" 
			hint="create or update an issue">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="listkey" type="string" required="yes">
		<cfargument name="body_html" type="string" required="yes">
		<cfargument name="body_text" type="string" required="yes">
		<cfargument name="auto_generate_text_version" type="numeric" required="no" default="1">
		<cfargument name="issue_name" type="string" required="yes">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="description" type="string" required="yes">
		<cfargument name="dt_send" type="date" required="yes">
		<cfargument name="approved" type="numeric" default="0" required="yes">
		<cfargument name="attachmentkeys" type="string" required="no" default="" hint="entrykeys of files to attach">
		
		<!--- check permission --->
	
		<!--- delete old record ... insert new one ... --->
		<cfinclude template="queries/q_delete_old_issue_version.cfm">
		<cfinclude template="queries/q_insert_issue.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CreateOrUpdateNewsletterProfile" output="false" returntype="struct" hint="create a newsletter profile">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="name" type="string" hint="name of newsletter">
		<cfargument name="description" type="string" required="yes" hint="description">
		<cfargument name="manage_subscriptions" type="numeric" required="yes">
		<cfargument name="open_tracking" type="numeric" required="yes">
		<cfargument name="default_format" type="string" required="yes" hint="html or text">
		<cfargument name="type" type="numeric" default="0" required="yes" hint="0 = dynamic, 1 = static, 2 = select subscribers">
		<cfargument name="crm_filter_key" type="string" required="no" default="" hint="entrykey of crm filter used for dynamic list">
		<cfargument name="sender_name" type="string" required="yes" hint="name of server">
		<cfargument name="sender_address" type="string" required="yes" hint="address of sender">
		<cfargument name="replyto" type="string" required="no" default="" hint="reply to address">
		<cfargument name="confirmation_url_subscribed" type="string" required="no" default="">
		<cfargument name="confirmation_url_unsubscribed" type="string" required="no" default="">
		<cfargument name="default_header" type="string" required="no" default="">
		<cfargument name="default_footer" type="string" required="no" default="">
		<cfargument name="langno" type="numeric" required="no" default="0">
		<cfargument name="test_addresses" type="string" default="" hint="test addresses for test runs">
		
		<cfset var stReturn = StructNew()>
		
		<!--- delete old item ... --->
		<cfinclude template="queries/q_delete_old_profile.cfm">
		
		<!--- insert new item ... --->		
		<cfinclude template="queries/q_insert_newsletter_profile.cfm">
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="GetSimpleNewsletterprofile" output="false" returntype="query" hint="return profile without securitycontext">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_profile_simple.cfm">
		
		<cfreturn q_select_profile_simple>		
	</cffunction>
	
	<cffunction access="public" name="GetNewsletterprofile" output="false" returntype="query" hint="return a single profile">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
				
		<cfset var a_str_cache_profile = 'q_select_newsletter_profile_' & hash(arguments.entrykey)>
		
		<!--- if cached version does not exist ... load and set now ... --->
		<cfif NOT StructKeyExists(request, a_str_cache_profile)>
			<cfset request[a_str_cache_profile] = GetNewsletterProfiles(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykeys = arguments.entrykey)>
		</cfif>
		
		<cfreturn request[a_str_cache_profile]>
	</cffunction>
	
	<cffunction access="public" name="GetNewsletterProfiles" output="false" returntype="query" hint="return all profiles">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="filter" type="string" required="no">
		<cfargument name="entrykeys" type="string" required="no" default="" hint="list of entrykeys to filter">
		
		<cfinclude template="queries/q_select_newsletter_profiles.cfm">
		
		<cfreturn q_select_newsletter_profiles>
		
	</cffunction>
	
	<cffunction access="public" name="GetNewsletterJobs" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="newsletterkey" type="string" required="no" default="">
		
		<!--- select jobs ... --->
	</cffunction>
	
	<cffunction access="public" name="CreateNewsletterJob" output="false" returntype="struct" hint="a new sending ...">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="newsletterkey" type="string" required="yes" hint="entrykey of newsletter profile">
		<cfargument name="job_name" type="string" required="yes" hint="title of this particular job">
		<cfargument name="dt_send" type="date" required="yes" hint="when to send">
		<cfargument name="crmfilterkeys" type="string" required="no" default="">
		
		<cfset var stReturn = StructNew()>
		
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="ReplaceVariables" output="false" returntype="string" hint="place various variables">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of this recipient in the send table (NOT entrykey in the contacts table)">
		<cfargument name="input" type="string" required="yes">
		<cfargument name="listkey" type="string" required="yes" hint="entrykey of list">
		<cfargument name="issuekey" type="string" required="yes" hint="entrykey of issue">
		<cfargument name="query_holding_data_to_replace" type="query" required="no" default="#QueryNew('entrykey')#" hint="query e.g. with contact data">
		<cfargument name="query_own_datafields_crm" type="query" required="no" default="#QueryNew('showname,fieldname')#" hint="query holding information about own crm fields ...">
		<cfargument name="langno" type="numeric" default="0" required="no" hint="number of language (for automated replaces ...">
		
		<cfset var sReturn = '' />
		<cfset var q_select_profile = 0 />
		<cfset var sReturn_new = '' />
		<cfset var a_str_showname = '' />
		<cfset var a_str_real_showname = '' />
		<cfset var a_str_salutation = '' />
		<cfset var a_str_single_line = '' />
		<cfset var a_str_item_name = '' />
		<cfset var a_str_item_name_without_db = '' />
		<cfset var a_str_new_value = '' />
		
		<cfset sReturn = arguments.input>
		
		<cfif NOT StructKeyExists(request, 'a_component_lang')>
			<cfset request.a_component_lang = application.components.cmp_lang />
		</cfif>
		
		<!--- load profile ... --->
		<cfset q_select_profile = GetNewsletterprofile(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.listkey)>
		
		<cfinclude template="utils/inc_replace_variables.cfm">
		
		<cfreturn sReturn>
	</cffunction>
	
</cfcomponent>
