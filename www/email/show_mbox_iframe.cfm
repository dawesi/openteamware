<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfparam name="url.mailbox" type="string" default="INBOX">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<html>
<head>
<title>Mailbox</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.viewmode"
	defaultvalue1 = "rows"
	userparameter = 'url.style'
	savesettings = true
	setcallervariable1 = "a_str_mbox_display_style">
	
<cfif a_str_mbox_display_style IS 'rows'>
	<!--- display the message preview? --->
	<cfmodule template="../common/person/getuserpref.cfm"
		entrysection = "email"
		entryname = "mbox.display.msgpreview"
		defaultvalue1 = "1"
		savesettings = true
		setcallervariable1 = "a_int_display_mbox_msg_preview">
<cfelse>
	<cfset a_int_display_mbox_msg_preview = 1>
</cfif>

<cfif a_str_mbox_display_style IS 'rows'>
	<cfset a_str_fs = 'rows="60%,40%"'>
<cfelse>
	<cfset a_str_fs = 'cols="320,*"'>
</cfif>

<cfif a_int_display_mbox_msg_preview IS 1>

<frameset framespacing="4" frameborder="1" border="4" bordercolor="silver" <cfoutput>#a_str_fs#</cfoutput>>
	<frame frameborder="2" src="default.cfm?action=ShowMailboxContent&userkey=<cfoutput>#url.userkey#</cfoutput>&mailbox=<cfoutput>#urlencodedformat(url.mailbox)#</cfoutput>&style=<cfoutput>#a_str_mbox_display_style#</cfoutput>&displaymessagepreview=<cfoutput>#a_int_display_mbox_msg_preview#</cfoutput>" name="frameemailmailbox" id="frameemailmailbox" scrolling="auto" marginwidth="0" marginheight="0">
	<frame frameborder="0" src="default.cfm?action=showmessage" name="frameemailmessage" id="frameemailmessage" scrolling="auto" marginwidth="0" marginheight="0" borderColor="silver">
</frameset><noframes></noframes>

<cfelse>
	
	<!--- display old version ... --->
	<cflocation addtoken="no" url="default.cfm?action=ShowMailboxContent&mailbox=#urlencodedformat(url.mailbox)#&style=rows&displaymessagepreview=0&userkey=#url.userkey#">

</cfif>

</html>
