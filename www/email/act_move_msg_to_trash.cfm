<!--- //

	move a selected message to the trash folder
	
	// --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">
<cfinclude template="../common/scripts/script_utils.cfm">
	
<cfparam name="url.id" default="0" type="numeric">
<cfparam name="url.mailbox" default="INBOX" type="string">

<cfinvoke component="/components/email/cmp_tools"
		method="moveorcopymessage"
		returnvariable="sReturn">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="INBOX.Trash">
		<cfinvokeargument name="copymode" value="0">
		<cfinvokeargument name="uid" value="#url.id#">
</cfinvoke>
		
<!--- speedMode enabled? --->
<!---<cfset a_str_request_query_name = "request.q_select_my_mailbox_"&GetBeautyfulMailboxname(url.mailbox)>
<cfset a_str_session_query_name = "session.q_select_my_mailbox_"&GetBeautyfulMailboxname(url.mailbox)>
<cfif IsDefined(a_str_request_query_name)>
	<!--- yes ... --->
	<cfset SetVariable(a_str_session_query_name, QueryDeleteRows(Evaluate(a_str_request_query_name), url.currentrow))>
	<cfdump var="#Evaluate(a_str_session_query_name)#">
</cfif>
<cfabort>--->		
<cflocation addtoken="no" url="#ReturnRedirectURL()#">