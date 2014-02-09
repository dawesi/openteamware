<!--- //

	Module:		Email
	Action:		EmptyFolder
	Description:Empty a folder (delete all messages older than n days
	

	
	
	Only allowed for Trash, Drafts and Junkmail
	
// --->


<cfparam name="url.foldername" type="string" default="INBOX.Trash">
<cfparam name="url.maxage" type="numeric" default="10">

<cfinclude template="../utils/inc_load_imap_access_data.cfm">


<cfif ListFindNoCase("INBOX.Junkmail,INBOX.Trash,INBOX.Drafts", url.foldername, ",") is 0>
	<cfabort>
</cfif>

<cfset url.mailbox = url.foldername />
<cfinclude template="queries/q_delete_mbox_cache.cfm">

<cfinvoke component="/components/email/cmp_tools" method="emptyfolder" returnvariable="stReturn">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="#url.foldername#">
	<cfinvokeargument name="maxage" value="#url.maxage#">
</cfinvoke>

<html>
	<head>
	<meta http-equiv="refresh" content="3;URL=/email/">
	</head>
<body>
	<div style="text-align:center;padding:100px;">
		<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
	</div>
</body>
</html>

