<cfparam name="url.entrykey" type="string" default="">

<!--- load event ... --->
<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<html>
<head>
<script type="text/javascript">
	function CloseWindow()
		{
		alert('Der Termin wurde erfolgreich eingetragen');
		window.close();
		}
</script>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="CloseWindow();">

<a href="javascript:window.close();">Close Window</a>

</body>
</html>
