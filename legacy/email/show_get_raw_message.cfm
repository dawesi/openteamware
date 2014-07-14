<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.mailbox" type="string" default="INBOX">
<cfparam name="url.id" type="numeric" default="0">

<html>
<head>
<title>Quelltext</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfinclude template="utils/inc_load_imap_access_data.cfm">


<cfinvoke
	component="/components/email/cmp_tools"
	method="getrawmessage"
	returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="savepath" value="#request.a_str_temp_directory#">
	</cfinvoke>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_str_result">#a_str_result#</cfmail>--->

<cfheader name="Content-disposition" value="attachment;filename=""email.eml""">
<cfcontent deletefile="no" file="#a_str_result#" type="binary/unknown">

<!---
<cffile action="read" file="#a_str_result#" variable="a_str_mail" charset="ISO-8859-1">

<pre>
<cfoutput>#htmleditformat(a_str_mail)#</cfoutput>
</pre>--->
</body>
</html>
