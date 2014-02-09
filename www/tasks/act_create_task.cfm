<!--- //

	create a new task
	
	// --->
	
<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="default.cfm?action=newtask">
</cfif>

<cfparam name="form.frmprivate" type="numeric" default="0">
<cfparam name="form.frm_assigned_addressbookkeys" type="string" default="">
<cfparam name="form.frmsource" type="string" default="">

<cfset request.sCurrentServiceKey = "52230718-D5B0-0538-D2D90BB6450697D1">
	
<cfinclude template="../login/check_logged_in.cfm">


<!--- create the task now

	--->
	
<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="notice" value="#form.frmnotice#">
	<cfinvokeargument name="priority" value="#form.frmpriority#">
	<cfinvokeargument name="percentdone" value="#val(form.frmpercentdone)#">
	<cfinvokeargument name="status" value="#form.frmstatus#">
	<cfinvokeargument name="actualwork" value="#val(form.frmactualwork)#">
	<cfinvokeargument name="totalwork" value="#val(form.frmtotalwork)#">
	<cfinvokeargument name="categories" value="#form.frmcategories#">
	<cfinvokeargument name="assignedtouserkeys" value="#form.frmassignedtouserkeys#">
	
	<!--- is the due date given? --->
	<cfif StructKeyExists(form, "frmdt_due") AND isDate(form.frmdt_due)>
		<cfinvokeargument name="due" value="#LSParseDateTime(form.frmdt_due)#">
	</cfif>
	
	<cfinvokeargument name="private" value="#form.frmprivate#">
	
</cfinvoke>

<cfloop list="#form.frm_assigned_addressbookkeys#" index="a_str_assigned_contactkey">
	<cfinvoke component="#application.components.cmp_crmsales#" method="CreateItemConnectionToContact" returnvariable="a_dummy">
		<cfinvokeargument name="contactkey" value="#a_str_assigned_contactkey#">
		<cfinvokeargument name="objectkey" value="#form.frmentrykey#">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	</cfinvoke>
</cfloop>


<!--- set assigned users ... --->
<cfloop list="#form.frmassignedtouserkeys#" delimiters="," index="a_str_userkey">
	<cfinvoke component="#request.a_str_component_tasks#" method="AddAssignedUserToTask" returnvariable="stReturn">
		<cfinvokeargument name="taskkey" value="#form.frmentrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="userkey" value="#a_str_userkey#">
	</cfinvoke>
	
	<cfif stReturn.result IS TRUE AND stReturn.a_bol_newlyassigned IS TRUE>
	
		<!--- send email about that --->
		<cfinvoke component="#request.a_str_component_tasks#" method="SendAlertAboutNewAssignedTask" returnvariable="a_bol_return">
			<cfinvokeargument name="taskkey" value="#form.frmentrykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
		</cfinvoke>
	
	</cfif> 
</cfloop>

<!--- edit projectkey ... --->
<!---<cfinvoke component="#request.a_str_component_project#" method="AddOrUpdateItemConnection" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkey" value="#form.frmentrykey#">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="projectkey" value="#form.frmprojectkeys#">
</cfinvoke>--->

<cfif form.frmsource IS 'crm'>
	<!--- just close the window --->
	<html>
		<head>
			<script type="text/javascript">
				function DoWindowClose()
					{
					window.close();
					}
			</script>
			<title>Done</title>
		</head>
		<body onLoad="DoWindowClose();">
			<a href="javascript:DoWindowClose();">close</a>
		</body>
	</html>
	<cfexit method="exittemplate">
</cfif>
	
<cfif StructKeyExists(form, 'frmSubmitAddAnother')>
	<cflocation addtoken="no" url="default.cfm?action=newtask">
<cfelse>
	<!--- forward to the new item ... ---->
	<cflocation addtoken="no" url="default.cfm?action=ShowTask&entrykey=#urlencodedformat(form.frmentrykey)#">
</cfif>
