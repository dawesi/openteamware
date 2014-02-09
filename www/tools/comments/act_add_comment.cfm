
<cfif NOT CheckSimpleLoggedIn()>
	<cfabort>
</cfif>

<cfparam name="form.frmservicekey" type="string" default="">

<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="queries/q_insert_comment.cfm">


<!--- check if we can modify the object (new comment ...) --->
<cfswitch expression="#form.frmservicekey#">
	<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
	<!--- task ... --->
	
	<cfinvoke component="/components/tasks/cmp_task" method="UpdateTask" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#form.frmobjectkey#">
		<cfinvokeargument name="newvalues" value="#StructNew()#">
	</cfinvoke>
	
	</cfcase>
</cfswitch>

<html>
<head>

</head>
<body>
<script type="text/javascript">
	window.opener.location.reload();
	window.close();
</script>
</body>
</html>