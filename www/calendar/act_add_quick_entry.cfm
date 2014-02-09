<cfinclude template="../login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="form.frmbegin_hour" type="numeric" default="#Hour(now())#">
<cfparam name="form.frmbegin_minutes" type="numeric" default="#Minute(now())#">
<cfparam name="form.frmdateday" type="numeric" default="#Day(now())#">
<cfparam name="form.frmdatemonth" type="numeric" default="#month(now())#">
<cfparam name="form.frmdateyear" type="numeric" default="#year(now())#">
<cfparam name="form.frmduration" type="numeric" default="1">

<cfparam name="form.frmtitle" type="string" default="">

<cfif len(form.frmtitle) is 0>
	<cfset form.frmtitle = CheckZerostring('')>
</cfif>

<cfset a_dt_start = GetUTCTime(CreateDateTime(form.frmdateyear, form.frmdatemonth, form.frmdateday, form.frmbegin_hour, form.frmbegin_minutes, 0))>

<cfset a_dt_end = DateAdd('h', form.frmduration, a_dt_start)>

<!--- add entry now ... --->
<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="date_start" value="#a_dt_start#">
	<cfinvokeargument name="date_end" value="#a_dt_end#">
</cfinvoke>


<!---
	return to the previous view ...
	--->
<cflocation addtoken="no" url="#ReturnRedirectURL()#">