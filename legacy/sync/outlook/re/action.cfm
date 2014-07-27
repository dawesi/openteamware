<cfparam name="form.frmcb" type="string" default="">

<cfloop list="#form.frmcb#" delimiters="," index="sEntrykey">

	<cftry>

	<cfinvoke component="#application.components.cmp_addressbook#" method="ActivateRemoteEdit" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#sEntrykey#">
		<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#session.stUserSettings#">		
	</cfinvoke>
	
	<cfcatch type="any">
	
	</cfcatch>
	</cftry>

</cfloop>

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<script type="text/javascript">
	window.location.href = 'mrclosenow';
</script>

</body>
</html>
