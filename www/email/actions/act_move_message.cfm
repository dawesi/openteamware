<!--- //

	Module:		EMail
	Action:		DoMoveMessage
	Description: 
	

// --->

<cfinclude template="../utils/inc_load_imap_access_data.cfm">

<cfinclude template="../queries/q_select_all_pop3_data.cfm">

<cfparam name="url.id" default="0" type="numeric">
<cfparam name="url.mailbox" default="" type="string">
<cfparam name="url.redirect" default="" type="string">
<!--- optional ... check data ... --->
<cfparam name="url.mbox_md5" type="string" default="">
<cfparam name="url.targetmailbox" type="string" default="">
<cfparam name="url.afrom" type="string" default="">
<cfparam name="url.ato" type="string" default="">

<cfinclude template="queries/q_delete_mbox_cache.cfm">

<cfinvoke component="/components/email/cmp_tools" method="moveorcopymessage" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="#url.targetmailbox#">
		<cfinvokeargument name="copymode" value="false">		
</cfinvoke>

<cfset a_str_own_email_adr = ValueList(q_select_all_pop3_data.emailadr) />

<cfif ListFindNoCase(a_str_own_email_adr, url.afrom) IS 0>
	<cfset a_str_save_value_move_adr = url.afrom />
<cfelse>
	<cfset a_str_save_value_move_adr = url.ato />
</cfif>

<!--- save target folder for this email address ... --->
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.movedefaultfolder.#url.mailbox#.#a_str_save_value_move_adr#"
	entryvalue1 = #url.targetmailbox#>

<cfif url.redirect IS 'nextmsg'>
	<!--- goto next message ... --->
	<cfmodule template="../utils/inc_check_next_msg.cfm"
		md5_querystring = #url.mbox_md5#
		mailbox = #url.mailbox#
		id = #url.id#>

<cfelseif len(url.redirect) gt 0>
	<cflocation addtoken="no" url="#urldecode(url.redirect)#">
<cfelse>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

