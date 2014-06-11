<!--- //

	Component:     E-Mail Account Management
	Description:   Edit, delete, modify accounts
	
	Parameters

// --->
	
<cfcomponent output="false"
	hint="various functions for managing email accounts (add, edit, delete)">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="CreateInternalEmailAccount" output="false" returntype="boolean"
			hint="Create a new internal email account (which is fully operable)">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of new item">
		<cfargument name="emailaddress" type="string" required="true"
			hint="the new email address">
		<cfargument name="server" type="string" required="true"
			hint="server name">
		<cfargument name="password" type="string" required="true"
			hint="the password">
		<cfargument name="displayname" type="string" default="" required="false"
			hint="name to display ...">
		<cfargument name="port" type="numeric" default="143" required="false"
			hint="IMAP port">
		<cfargument name="SSL" type="numeric" default="0" required="false"
			hint="use SSL? 0 / 1">
		<cfargument name="quota" type="numeric" default="2097152000" required="false"
			hint="quota ... default = 200MB">
		<cfargument name="origin" type="numeric" default="0"
			hint="origin ... 0 = main default address, 1 = any further address">
		<cfargument name="createconfig" type="boolean" default="true"
			hint="create config (procmail, ...)">
		<cfargument name="spamassassin_enabled" type="boolean" default="false" required="false">
		<cfargument name="spamassassin_found_action" type="numeric" default="2"
			hint="default = move to junkmail folder">
		<cfargument name="spamassassin_destination_folder" type="string" default=".Junkmail"
			hint="default junkmail folder">
		<cfargument name="userid" type="numeric" required="true"
			hint="userid of user to which this account belongs">
		<cfargument name="userkey" type="string" required="true"
			hint="userkey of user">
		<cfargument name="createstandardfolders" type="boolean" required="true" default="false"
			hint="create default folders ...">
		
		<cfset var sReturn = '' />
		<cfset var a_bol_return = false />
		<cfset var stReturn_createstandardfolders = 0 />
		<cfset var q_insert_pop3_data = 0 />
		
		<cfset arguments.emailaddress = lcase(arguments.emailaddress) />
		
		<!--- insert into table pop3_data ... --->		
		<cfinclude template="queries/q_insert_pop3_data.cfm">
		
		<!--- create postfix record ... --->
		<!--- <cfset sReturn = CreatePostfixRecord(emailaddress = arguments.emailaddress,
								password = arguments.password,
								userkey = arguments.userkey)>
		
		<!--- create maildir now ... ---->
		<cfset CreateMailDirectory(arguments.emailaddress) />
		
		<!--- set spam assassin config now ... --->
		<cfset a_bol_return = UpdateOrInsertSpamassassinEntry(emailaddress = arguments.emailaddress,
								action = arguments.spamassassin_found_action,
								enabled	= arguments.spamassassin_enabled,
								spamtargetfolder = arguments.spamassassin_destination_folder)>
		
		<cfif arguments.createstandardfolders is true>
			<!--- create standard folders ... --->
			<cfinvoke component="cmp_tools" method="CreateStandardFolders" returnvariable="stReturn_createstandardfolders">
  				<cfinvokeargument name="server" value="#arguments.server#">
  				<cfinvokeargument name="username" value="#arguments.emailaddress#">
  				<cfinvokeargument name="password" value="#arguments.password#">
			</cfinvoke>
		</cfif>
		
		<!--- insert quota entry ... --->
		<cfset UpdateOrInsertQuotaEntry(arguments.emailaddress, arguments.quota)>
		
		<cfif arguments.createconfig is true>
			<cfset CreateMailConfig(arguments.emailaddress)>
		</cfif> --->
		
		<cfreturn true />
	</cffunction>
	
	<!--- create an external address ... table emailaccounts ... --->
	<cffunction access="public" name="CreateExternalAddress" output="false" returntype="string">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		<!--- userid ... --->
		<cfargument name="userid" type="numeric" required="true">
		<!--- external host ... --->
		<cfargument name="host" type="string" required="true">
		<!--- username ... --->
		<cfargument name="username" type="string" required="true">
		<!--- password ---->
		<cfargument name="password" type="string" required="true">
		<!--- leave msg on server? ---->
		<cfargument name="leavemsgonserver" type="boolean" default="true">
		<!--- check each x minutes ... --->
		<cfargument name="checkeachnminutes" type="numeric" default="30">
		
		<!--- to-do: insert into emailaccounts table ... --->
		
		<cfset var sEntrykey = CreateUUID() />
		
		<cfreturn sEntrykey>
	
	</cffunction>
	
	<!--- create quota entry ... --->
	<cffunction access="public" name="UpdateOrInsertQuotaEntry" output="false" returntype="boolean">
		<!--- username ... --->
		<cfargument name="username" type="string" required="true">
		<!--- maximal size ... default = 200 MB --->
		<cfargument name="maxsize" type="numeric" required="true" default="209715200">
		
		<!--- delete now old entry and insert new one ... --->
		<cfinclude template="queries/q_delete_quota_entry.cfm">
		
		<!--- insert new entry ... --->
		<cfinclude template="queries/q_insert_quota.cfm">
		
		<!--- update config ... --->
		<cfhttp url="#request.a_str_url_updatemaildirsizeurl##urlencodedformat(arguments.username)#" resolveurl="no"></cfhttp>
		
		<cfreturn true>
	</cffunction>
	
	<!--- create the mail config ... --->
	<cffunction access="public" name="CreateMailConfig" output="false" returntype="boolean">
		<cfargument name="emailaddress" type="string" required="true">
		
		<!--- call create config script ... --->
		<cfhttp url="#request.a_str_url_generateprocmailconfigurl##urlencodedformat(arguments.emailaddress)#" resolveurl="no"></cfhttp>
		
		
		<cfreturn true>
	</cffunction>
	
	<!--- create the mail directory ... --->
	<cffunction access="public" name="CreateMailDirectory" output="false" returntype="boolean">
		<cfargument name="emailaddress" type="string" required="true">
		
		<!--- call the create mail dir script ... --->
		<cfhttp url="#request.a_str_url_createmaildirurl##urlencodedformat(arguments.emailaddress)#" resolveurl="no"></cfhttp>
		
		<cfreturn true>
	</cffunction>
	
	<!--- create or edit spam assassin configuration ... --->
	<cffunction access="public" name="UpdateOrInsertSpamassassinEntry" output="false" returntype="boolean">
		<cfargument name="emailaddress" type="string" required="true"
			hint="the username">
		<cfargument name="enabled" type="boolean" default="true"
			hint="enabled?">
		<cfargument name="action" type="numeric" default="2"
			hint="action?">
		<cfargument name="spamtargetfolder" type="string" default=".Junkmail"
			hint="spam target folder ...">

		<cfset var a_int_enabled = 0 />
		
		<!--- delte old data, insert new one ... --->
		<cfinclude template="queries/q_delete_sa_entry.cfm">
		
		<cfif arguments.enabled>
			<cfset a_int_enabled = 1 />
		<cfelse>
			<cfset a_int_enabled = 0 />
		</cfif>
		
		<cfinclude template="queries/q_insert_sa_record.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="CreatePostfixRecord" output="false" returntype="string"
			hint="create postfix user (MTA, IMAP) ...">
		<cfargument name="emailaddress" type="string" required="true"
			hint="email address">
		<cfargument name="password" type="string" required="true"
			hint="the password">
		<cfargument name="userkey" type="string" required="true"
			hint="userkey of the user">
		<cfargument name="spool" type="string" default="default"
			hint="any special spool directory (n/a yet)">
		
		<cfset var sEntrykey = CreateUUID() />
		<!--- get domain ... --->
		<cfset var ii = FindNoCase("@", arguments.emailaddress) />
		
		<!--- get domain and username ... --->
		<cfset var a_str_domain = Mid(arguments.emailaddress, ii+1, len(arguments.emailaddress)) />
		<cfset var a_str_username = Mid(arguments.emailaddress, 1, ii-1) />
		
		<!--- default maildir and directory of user ... --->
		<cfset var a_str_mountpoint = request.appsettings.properties.SpoolDirectory1 />
		
		<cfset var a_str_maildir = request.appsettings.properties.SpoolDirectory1 & a_str_domain & '/' & a_str_username & '/' />
		
		<cfinclude template="queries/q_insert_postfix_record.cfm">		
		
		<cfreturn sEntrykey />
	</cffunction>
	
	<cffunction access="public" name="GetSpamassassinSettings" output="false" returntype="query"
			hint="return the spam assassin config for a specified account">
		<cfargument name="username" type="string" required="true"
			hint="the username to return the settings for">
		
		<cfinclude template="queries/q_select_spamguard_settings.cfm">
		<cfreturn q_select_spamguard_settings />
	</cffunction>
	
	<cffunction access="public" name="UpdateForwarding" output="false" returntype="boolean"
			hint="update a forwarding ...">
		<!--- source --->
		<cfargument name="source" type="string" required="true">
		<!--- destination --->
		<cfargument name="destination" type="string" required="true">
		<!--- leavecopy? --->
		<cfargument name="leavecopy" type="numeric" default="0" required="false">
		<!--- create the config? --->
		<cfargument name="createconfig" type="boolean" default="true" required="false">
		
		
		<cfset var DeleteForwardingRequest = StructNew() />
		
		<!--- delete old entry and insert new one ... --->
		<cfset DeleteForwardingRequest.emailaddress = arguments.source>
		<cfinclude template="queries/q_delete_forwarding.cfm">
		
		<!--- insert now new forwarding --->
		<cfinclude template="queries/q_insert_forwarding.cfm">
		
		<cfif arguments.createconfig>
			<cfset CreateMailConfig(arguments.source)>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteForwarding" output="false" returntype="boolean">
	
		<cfreturn true>
	</cffunction>
	
	<!--- check if a forwarding exists ... if '' is returned, no forwarding is enabled --->
	<cffunction access="public" name="GetForwarding" output="false" returntype="struct">
		<cfargument name="emailaddress" type="string" required="true">
		
		<cfset var stReturn = StructNew() />
		<cfset var q_select_forwarding = 0 />
		
		<cfinclude template="queries/q_select_forwarding.cfm">
		
		<cfset stReturn.exists = (q_select_forwarding.recordcount IS 1) />
		<cfset stReturn.destination = q_select_forwarding.destination />
		<cfset stReturn.leavecopy = q_select_forwarding.leavecopy />
		
		<cfreturn stReturn />
	</cffunction>
	
	<!--- get signature ... --->
	<cffunction access="public" name="GetSignatureOfEmailAddress" output="false" returntype="string">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		<!--- email address ... --->
		<cfargument name="emailaddress" type="string" required="true">
		
		<cfinclude template="queries/q_select_signature.cfm">		
		
		<cfreturn q_select_signature.signature>
	</cffunction>
	
	<cffunction access="public" name="GetEmailAccounts" returntype="query" output="false"
			hint="return all set up email accounts (internal, pop3, ...) of an user">
		<cfargument name="userkey" type="string" required="true"
			hint="the entrykey of the user">
	
		<cfinclude template="queries/q_select_pop3_data.cfm">
		
		<cfreturn q_select_pop3_data />
	
	</cffunction>
	
	<cffunction access="public" name="GetAliasAddresses" returntype="query" output="false">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_email_aliases.cfm">
		
		<cfreturn q_select_email_aliases />
	</cffunction>
	
		<cffunction access="public" name="RemoveAliasAddress" returntype="boolean" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="true">
		
		<cfset var a_bol_return = false />
		<cfset var q_select_alias_exists = 0 />
		
		<!--- check if alias address exists --->
		<cfinclude template="queries/q_select_alias_exists.cfm">
		
		<cfif q_select_alias_exists.count_id IS 0>
			<cfreturn false />
		</cfif>
		
		<cfinvoke component="cmp_accounts" method="DeleteWholeEmailAccount" returnvariable="a_bol_return">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
			<cfinvokeargument name="companykey" value="#arguments.companykey#">
			<cfinvokeargument name="emailaddress" value="#arguments.emailaddress#">
		</cfinvoke>
		
		<cfinclude template="queries/q_delete_alias_address.cfm">
		
		<cfreturn a_bol_return>
	</cffunction>
	
	<!--- create an alias ... --->
	<cffunction access="public" name="CreateAlias" output="false" returntype="struct">
		<!--- companykey ... --->
		<cfargument name="companykey" type="string" required="true">
		<!--- which user has created this account? --->
		<cfargument name="createdbyuserkey" type="string" required="true">
		<!--- the key of the owner user --->
		<cfargument name="userkey" type="string" required="true">
		<!--- source address --->
		<cfargument name="aliasaddress" type="string" required="true">
		<!--- destination --->
		<cfargument name="destinationaddress" type="string" required="true">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_bol_return = false />
		
		
		<cfif ExtractEmailAdr(arguments.aliasaddress) IS ''>
			<cfset stReturn.error = true>
			<cfset stReturn.errormsg = 'Invalid address'>
			<cfreturn stReturn>
		</cfif>
		
		<cfif EmailAddressInUse(arguments.aliasaddress) IS TRUE>
			<cfset stReturn.error = true>
			<cfset stReturn.errormsg = 'address already in use'>
			<cfreturn stReturn>
		</cfif>
		
		<!--- create the postfix account ... --->
		<cfinvoke component="cmp_accounts" method="CreatePostfixRecord" returnvariable="a_bol_return">
			<cfinvokeargument name="emailaddress" value="#arguments.aliasaddress#">
			<cfinvokeargument name="password" value="#CreateUUID()#">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>
		
		<!--- create the maildir --->
		<cfset CreateMailDirectory(arguments.aliasaddress) />
		
		<!--- create the mail config ... --->
		<cfset CreateMailConfig(arguments.aliasaddress)>
		
		<!--- create the forwarding ... --->
		<cfinvoke component="cmp_accounts" method="UpdateForwarding" returnvariable="a_bol_return">
			<cfinvokeargument name="source" value="#arguments.aliasaddress#">
			<cfinvokeargument name="destination" value="#arguments.destinationaddress#">
			<cfinvokeargument name="leavecopy" value="0">
			<cfinvokeargument name="createconfig" value="true">
		</cfinvoke>
		
		<!--- create the mail config again ... --->
		<cfset CreateMailConfig(arguments.aliasaddress)>		
		
		<!--- insert into internal table --->
		<cfinclude template="queries/q_insert_alias.cfm">
		
		<!--- log this action ... --->
		
		<cfset stReturn.error = false>
		<cfreturn stReturn>
	</cffunction>
	
	<!---
		
		update the password for an account ... 
		
		--->
	<cffunction access="public" name="UpdateEmailPassword" output="false" returntype="boolean">
		<!--- the userkey --->
		<cfargument name="userkey" type="string" required="true">
		<!--- the email address --->
		<cfargument name="emailaddress" type="string" required="true">
		<!--- the new password --->
		<cfargument name="password" type="string" required="true">
		
		<cfif (Len(arguments.userkey) GT 0) AND (Len(arguments.emailaddress) GT 0) AND (Len(arguments.password) GT 0)>
		
			<!--- update internal pop3_data --->
			<cfinclude template="queries/q_update_pop3_data_pwd.cfm">
			
			<!--- update postfix --->
			<cfinclude template="queries/q_update_postfix_pwd.cfm">
		
		</cfif>		
		<cfreturn true>
	
	</cffunction>
	
	<cffunction access="public" name="EmailAddressInUse" output="false" returntype="boolean">
		<cfargument name="emailaddress" type="string" required="true">
		
		<!--- check pop3_data --->
		<cfinclude template="queries/q_select_email_address_exists.cfm">
		
		<!--- check alias table ... --->
		<cfinclude template="queries/q_select_alias_address_exists.cfm">
				
		<cfif q_select_email_address_exists.count_account IS 0
			  AND
			  q_select_alias_address_exists.count_account IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction access="public" name="GetIMAPAccessdata" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="true">
		
		<cfset var q_select_pop3_data = 0 />
		<cfset var stReturn = StructNew() />
		
		<cfinclude template="queries/q_select_pop3_data.cfm">
		
		<cfquery name="q_select_pop3_data" dbtype="query">
		SELECT
			pop3username,pop3password,pop3server,port,usessl
		FROM
			q_select_pop3_data
		WHERE
			origin = 0
		;
		</cfquery>
		
		<!--- enabled? --->
		<cfset stReturn.enabled = (q_select_pop3_data.recordcount GT 0) />
		<cfset stReturn.a_str_imap_host = q_select_pop3_data.pop3server />
		<cfset stReturn.a_str_imap_username = q_select_pop3_data.pop3username />
		<cfset stReturn.a_str_imap_password = q_select_pop3_data.pop3password />
		<cfset stReturn.a_int_imap_port = q_select_pop3_data.port />
		<cfset stReturn.a_int_use_ssl = q_select_pop3_data.useSSL />
		
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="DeleteWholeEmailAccount" output="false" returntype="boolean">
		<cfargument name="emailaddress" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="deletemaildir" type="boolean" default="true" required="false">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_str_secret = CreateUUID() />
		<cfset var DeletePOP3data = StructNew() />
		<cfset var DeleteForwardingRequest = StructNew() />
		<cfset var a_str_url = '' />
		<cfset var q_select_alias_addresses = 0 />
		<cfset var a_bol_del_alias = false />
		<!--- log this event ... --->
		
		<!--- check if user exists ... --->
		<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
			<cfinvokeargument name="entrykey" value="#arguments.userkey#">
		</cfinvoke>
		
		<cfif StructKeyExists(stReturn, 'query') IS FALSE>
			<cfreturn false>
		</cfif>
		
		<!--- delete maildir? --->
		<cfif arguments.deletemaildir>
		
			<!--- delete maildir ... --->
			
			<cfinclude template="queries/q_insert_secret.cfm">
			
			<!--- TODO MODE URL to configuration file ... --->
			<cfset a_str_url = 'http://database02/cgi-bin/deletemaildir.pl?username=#urlencodedformat(arguments.emailaddress)#&seckey=#urlencodedformat(a_str_secret)#'>
			
			<!--- call delete command ... --->
			<cfhttp url="#a_str_url#" method="get"></cfhttp>
			
			<!--- delete secret ... --->
			<cfinclude template="queries/q_delete_secret.cfm">
		</cfif>
		
		
		<!--- delete postfix --->
		<cfinclude template="queries/q_delete_postfix_record.cfm">
		
		<!--- delete pop3 data ... --->
		<cfset DeletePOP3data.emailaddress = arguments.emailaddress>
		<cfset DeletePOP3data.userkey = arguments.userkey>
		<cfinclude template="queries/q_delete_pop3_data.cfm">
				
		<!--- delete filter --->
		<cfinclude template="queries/q_delete_all_filters.cfm">
		
		<!--- delete external / pop3 accounts --->
		<cfinclude template="queries/q_delete_external_accounts.cfm">
		
		<!--- delete forwarding ... --->
		<cfset DeleteForwardingRequest.emailaddress = arguments.emailaddress>
		<cfinclude template="queries/q_delete_forwarding.cfm">
		
		<!--- delete alias addresses ... --->
		<cfset q_select_alias_addresses = GetAliasAddresses(arguments.userkey)>
		
		<cfif q_select_alias_addresses.recordcount GT 0>
		
			<!--- select all alias addresses where the address to delete is the destinationaddress --->
			<cfquery name="q_select_alias_addresses" dbtype="query">
			SELECT
				*
			FROM
				q_select_alias_addresses
			WHERE
				destinationaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
			;
			</cfquery>
			
			<cfloop query="q_select_alias_addresses">
			
			<!--- delete the alias address --->
			<cfinvoke component="cmp_accounts" method="RemoveAliasAddress" returnvariable="a_bol_del_alias">
				<cfinvokeargument name="userkey" value="#arguments.userkey#">
				<cfinvokeargument name="companykey" value="#arguments.companykey#">
				<cfinvokeargument name="emailaddress" value="#q_select_alias_addresses.aliasaddress#">
			</cfinvoke>
			
			</cfloop>
		</cfif>
		
		<!--- delete sa perferenes ... --->
		<cfinclude template="queries/q_delete_sa_entry.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="GetMailProfile" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_mailprofile.cfm">
		
		<cfreturn q_select_mailprofile>
	</cffunction>
	
	<cffunction access="public" name="GetStandardAddressFromTag" output="false" returntype="string">
		<!--- return "john doe <john@doe.com>"	--->
		<cfargument name="userkey" type="string" required="yes">
		
		<!--- load all addresses --->
		<cfset var q_select_accounts = GetEmailAccounts(userkey = arguments.userkey) />
		
		<!--- load the userdata ... --->
		<cfset var a_struct_user_data = CreateObject('component', '/components/management/users/cmp_load_userdata').LoadUserData(entrykey = arguments.userkey)>
		
		<cfset var q_select_userdata = a_struct_user_data.query>
		
		<cfset var a_str_default_address = '' />
		<cfset var q_select_sender = 0 />
		
		<cfmodule template="/common/person/getuserpref.cfm"
			entrysection = "email"
			entryname = "defaultemailaccount"
			userid = #q_select_userdata.userid#
			defaultvalue1 = "#q_select_userdata.username#">
		
		<cfset a_str_default_address = a_str_person_entryvalue1>		
		
		<!--- check if the address exists and is valid ... --->
		<cfquery name="q_select_sender" dbtype="query">
		SELECT
			*
		FROM
			q_select_accounts
		WHERE
			emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_default_address#">
		;
		</cfquery>
		
		<cfif q_select_sender.recordcount IS 1>
			<cfreturn q_select_sender.displayname&' <'&q_select_sender.emailadr&'>'>
		<cfelse>
			<!--- select standard item ... --->
			<cfquery name="q_select_sender" dbtype="query">
			SELECT
				*
			FROM
				q_select_accounts
			WHERE
				emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_userdata.username#">
			;
			</cfquery>
			
			<cfreturn q_select_sender.displayname&' <'&q_select_sender.emailadr&'>'>
		</cfif>
		
	</cffunction>
</cfcomponent>
