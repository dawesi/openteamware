<cfparam name="form.frmcbassignedto" type="string" default="">

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="SetNewValues();">



<!--- set back javascript ... --->

<script type="text/javascript">
	function SetNewValues()
		{
		opener.RemoveAllAssignedUserkeys();
		opener.RemoveAllAssignedUserkeys();
		opener.RemoveAllAssignedUserkeys();
		opener.RemoveAllAssignedUserkeys();
		
		<cfloop list="#form.frmcbassignedto#" index="a_str_userkey">
		
			<!--- load username ... --->
			<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
					<cfinvokeargument name="entrykey" value="#a_str_userkey#">
			</cfinvoke>
			
			opener.SetUserKeyAssignedTo('<cfoutput>#jsstringformat(a_str_username)#</cfoutput>','<cfoutput>#jsstringformat(a_str_userkey)#</cfoutput>');
		</cfloop>

		window.close();		
		}
</script>

</body>
</html>
