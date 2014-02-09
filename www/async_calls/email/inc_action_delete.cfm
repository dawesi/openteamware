<!--- //

	delete a single message
	
	// --->
	
	
	
<cfinclude template="../../email/utils/inc_load_imap_access_data.cfm">

<cfparam name="url.id" default="0" type="numeric">
<cfparam name="url.mailbox" default="" type="string">

<cfset a_cmp_tools = CreateObject('component', '/components/email/cmp_tools')>

<cfif url.mailbox is "INBOX.Trash">
	<!--- really delete --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uids" value="#url.id#">		
	</cfinvoke>

<cfelse>
	<!--- move to trash --->	
	<cfinvoke component="#a_cmp_tools#" method="moveorcopymessage" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="INBOX.Trash">
		<cfinvokeargument name="copymode" value="false">			
	</cfinvoke>
	
</cfif>


