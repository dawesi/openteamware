<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfinvoke component="#request.a_str_component_session#" method="DeleteSessionKey" returnvariable="a_bol_return">
	<cfinvokeargument name="sessionkey" value="#cookie.ib_session_key#">
	<cfinvokeargument name="applicationname" value="#application.applicationname#">
</cfinvoke>

<cfset StructClear(session)>

<cflocation addtoken="no" url="index.cfm">

</body>
</html>
