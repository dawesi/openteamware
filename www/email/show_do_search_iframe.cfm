<!--- //

	Module:		E-Mail Search Iframe Box
	Description: 
	

// --->
<html>
<head>
<title>Mailbox</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8;">
</head>
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.search" type="string" default="">
<cfparam name="url.style" type="string" default="cols">
<cfparam name="url.attachments" type="numeric" default="0">
<cfparam name="url.isflagged" type="numeric" default="0">
<cfparam name="url.frmage" type="numeric" default="0">

<cfif url.style IS 'rows'>
	<cfset a_str_fs = 'rows="300,*"' />
<cfelse>
	<cfset a_str_fs = 'cols="275,*"' />
</cfif>

<frameset  framespacing="4" frameborder="1" border="1" bordercolor="gray" <cfoutput>#a_str_fs#</cfoutput>>
	<frame frameborder="0" src="default.cfm?action=ShowMailboxContentSearch&age=<cfoutput>#url.frmage#</cfoutput>&isflagged=<cfoutput>#url.isflagged#</cfoutput>&attachments=<cfoutput>#url.attachments#</cfoutput>&search=<cfoutput>#urlencodedformat(url.search)#</cfoutput>&mailbox=<cfoutput>#url.mailbox#</cfoutput>&style=cols" name="frameemailmailbox" scrolling="auto" marginwidth="0" marginheight="0">
	<frame frameborder="0" src="default.cfm?action=showmessage" name="frameemailmessage" scrolling="auto" marginwidth="0" marginheight="0" borderColor="silver">
</frameset><noframes></noframes>

</html>

