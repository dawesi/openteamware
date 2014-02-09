<!--- delete an email message and goto mailbox again --->
<cfinclude template="../login/check_logged_in.cfm">

<cfinclude template="utils/inc_load_imap_access_data.cfm">


<cfparam name="url.id" default="0" type="numeric">

<cfparam name="url.mailbox" default="" type="string">

<cfparam name="url.redirect" default="" type="string">

<!--- optional ... check data ... --->
<cfparam name="url.mbox_md5" type="string" default="">

<cfparam name="url.openfullcontent" type="numeric" default="0">
<!--- check ... --->

<!---
<cfset a_tc = GetTickCount()>
<cflog text="start delete msg" type="Information" log="Application" file="ib_delete_msg">--->

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
	<cfinvoke component="/components/email/cmp_tools" method="moveorcopymessage" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="INBOX.Trash">
		<cfinvokeargument name="copymode" value="false">			
	</cfinvoke>
	
	<!---<cflog text="moved #(GetTickCount() - a_tc)#)" type="Information" log="Application" file="ib_delete_msg">--->
</cfif>

<cfif url.redirect IS 'nextmsg'>
	<!--- goto next message ... --->
	<cfmodule template="utils/inc_check_next_msg.cfm"
		md5_querystring = #url.mbox_md5#
		mailbox = #url.mailbox#
		id = #url.id#>
		
<cfelseif len(url.redirect) gt 0>
	<cflocation addtoken="no" url="#urldecode(url.redirect)#">
<cfelse>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>