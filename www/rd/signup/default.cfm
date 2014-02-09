<cfparam name="url.source" type="string" default="">
<cfparam name="url.datakey" type="string" default="">


<!--- replaced NEW with ACCOUNT --->

<!---

	check what the current app settings are saying about this theme ... 
	
	where to go now ...

--->

<cfset a_cmp_customize = application.components.cmp_customize>
<cfset a_struct_main_settings = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'main')>

<!--- if we've got a sub-id ... use this sub-id as url.source --->
<cfif StructKeyExists(cookie, 'ib_affiliate_subid')>
	<cfset url.source = cookie.ib_affiliate_subid>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>

<head>

<meta http-equiv="Refresh" content="0;URL=/signup/account/?source=<cfoutput>#urlencodedformat(url.source)#</cfoutput>&datakey=<cfoutput>#urlencodedformat(datakey)#</cfoutput>">

	<title>Unbenannt</title>

</head>

<body>

<a href="/signup/account/?source=<cfoutput>#urlencodedformat(url.source)#</cfoutput>&datakey=<cfoutput>#urlencodedformat(datakey)#</cfoutput>">weiter ...</a>

</body>

</html>

