<!--- //

	check if a username is avaliable ...
	
	// --->

<cfparam name="url.username" type="string" default="">


<html>
<head>
<link href="standard.css" rel="stylesheet" media="all" rev="stylesheet" type="text/css">
<title><cfoutput>#htmleditformat(url.username)#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfif Len(ExtractEmailAdr(url.username)) is 0>
	No username entered.
	<cfabort>
</cfif>

<!--- check if this user exists ... --->
<cfinvoke component="#application.components.cmp_user#" method="UsernameExists" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#url.username#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('cm_wd_result')#</cfoutput></h4>
<br>
<cfoutput>#GetLangVal('adm_ph_user_exists')#</cfoutput>:<br><br>

<cfif a_bol_return>
<cfoutput>#GetLangVal('cm_wd_yes')#</cfoutput> - <font color="#FF0000"><cfoutput>#GetLangVal('adm_ph_new_account_user_already_exists')#</cfoutput></font>
<cfelse>
<cfoutput>#GetLangVal('cm_wd_no')#</cfoutput> - <font color="#009900"><cfoutput>#GetLangVal('adm_ph_new_account_user_free')#</cfoutput></font>
</cfif>

<br>
<br>
<input type="button" name="frmclose" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>" onClick="window.close();">

</body>
</html>
