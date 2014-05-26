<!---//

	delete a task ...
	
	// --->
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.return" type="string" default="">
	
<cfinclude template="../login/check_logged_in.cfm">


<cfif len(url.entrykey) is 0>
	<!--- invalid paramater ... --->
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<!--- load task and check permissions ... --->
<cfinvoke component="/components/tasks/cmp_task" method="DeleteTask" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_bol_return>
	<html>
		<head></head>
		<body>
			<script type="text/javascript">
				alert('Keine Berechtigung zum Loeschen gefunden.');
				history.go(-1);
			</script>
		</body>
	</html>
	<cfabort>
</cfif>


<!--- delete task and outlook items ... --->

<!--- forward ... --->
<cfif Len(url.return) GT 0>
	<cflocation addtoken="no" url="#url.return#">
<cfelse>
	<cflocation addtoken="no" url="index.cfm">
</cfif>
