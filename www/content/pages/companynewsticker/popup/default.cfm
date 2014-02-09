
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<cfinclude template="../../../../style_sheet.cfm">
<title>Nachrichten</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body style="padding:8px;background-color:orange;">

<cfset SelectCompanyNewsRequest.SelectTopNewsOnly = 1>
<cfinclude template="../queries/q_select_news.cfm">

<cfoutput query="q_select_news">
<h4>#q_select_news.title#</h4>

<a href="#q_select_news.href#" target="_blank">#q_select_news.href#</a>
</cfoutput>

</body>
</html>
