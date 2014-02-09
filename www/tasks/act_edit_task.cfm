<!---

	edit the task
	
	--->
	
<cfset request.sCurrentServiceKey = "52230718-D5B0-0538-D2D90BB6450697D1">
	
<cfinclude template="../login/check_logged_in.cfm">
	
<cfparam name="form.frmprivate" type="numeric" default="0">

<!--- fill a structure with the values that should be updated ... --->

<cfset stUpdate = StructNew()>

<cfset stUpdate.title = form.frmtitle>
<cfset stUpdate.entrykey = form.frmentrykey>

<cfif isDate(form.frmdt_due)>
	<cfset stUpdate.dt_due = LsParseDateTime(form.frmdt_due)>
<cfelse>
	<cfset stUpdate.dt_due = ''>
</cfif>

<cfset stUpdate.categories = form.frmcategories>
<cfset stUpdate.status = form.frmstatus>
<cfset stUpdate.percentdone = form.frmpercentdone>
<cfset stUpdate.priority = form.frmpriority>
<cfset stUpdate.actualwork = form.frmactualwork>
<cfset stUpdate.totalwork = form.frmtotalwork>
<cfset stUpdate.assignedtouserkeys = form.frmassignedtouserkeys>
<cfset stUpdate.private = form.frmprivate>
<cfset stUpdate.notice = form.frmnotice>

<cfinvoke component="/components/tasks/cmp_task" method="UpdateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>

<!--- edit projectkey ... --->
<cfinvoke component="#request.a_str_component_project#" method="AddOrUpdateItemConnection" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkey" value="#form.frmentrykey#">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="projectkey" value="#form.frmprojectkeys#">
</cfinvoke>

<!--- link back ... --->
<cflocation addtoken="no" url="default.cfm?action=ShowTask&entrykey=#urlencodedformat(form.frmentrykey)#">