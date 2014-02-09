<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryInformation"   
	returnVariable = "a_struct_dir"   
	directorykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	 >
</cfinvoke>

<cfset a_query_directory = a_struct_dir.q_select_directory />

<cfset a_str_domain = Mid(request.stSecurityContext.myusername, FindNoCase('@', request.stSecurityContext.myusername)+1, Len(request.stSecurityContext.myusername))>
<cfset a_str_username = Mid(request.stSecurityContext.myusername, 1, FindNoCase('@', request.stSecurityContext.myusername)-1)>
		
<cfset a_str_link = 'http://www.openTeamWare.com/storage/public.cfm/'&a_str_domain&'/'&a_str_username&'/'&a_query_directory.directoryname&'/'>
		
<cfset a_str_password = ''>

<cfif Len(a_query_directory.publicshare_password) GT 0>
	<cfset a_str_password = 'Passwort: '&a_query_directory.publicshare_password>
</cfif>
		
<cfset a_str_body = 'Guten Tag!' & chr(10) & request.a_struct_personal_properties.myfirstname&' '&request.a_struct_personal_properties.mysurname&' sendet Ihnen mit dieser Nachricht den Link zu einem oeffentlichen Ordner.'&chr(13)&chr(10)&chr(13)&chr(10)&'Link: '&a_str_link&chr(13)&chr(10)&a_str_password>
	
<cfset a_str_body = ReplaceNoCase(a_str_body, chr(10), '<br>', 'ALL')>
<html>
<head>
<script type="text/javascript">
	function compose()
		{
		window.open('/email/default.cfm?format=html&action=composemail&subject=Zugangsdaten&body=<cfoutput>#jsstringformat(a_str_body)#</cfoutput>', '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=600');
		location.href = '<cfoutput>#ReturnRedirectURL()#</cfoutput>';
		}
</script>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="compose();">

</body>
</html>
