<!--- //

	Module:		CRM
	Action:		DoCreateHistoryItem
	Description:Insert a new CRM history item
	

// --->

<cfparam name="form.frmservicekey" type="string">
<cfparam name="form.frmobjectkey" type="string">
<cfparam name="form.frmsubject" type="string" default="">
<cfparam name="form.frmcomment" type="string" default="">
<cfparam name="form.frmprojectkey" type="string" default="">
<cfparam name="form.frmlinked_servicekey" type="string" default="">
<cfparam name="form.frmlinked_objectkey" type="string" default="">

<cfparam name="form.frmdt_created" type="string" default="">
<cfparam name="form.FRMDT_CREATED_TIME_HOUR" type="numeric" default="0">
<cfparam name="form.FRMDT_CREATED_TIME_MINUTE" type="numeric" default="0">

<cfif IsDate(frmdt_created)>
	<cfset a_dt_created = LSParseDateTime(form.frmdt_created) />
	
	<!--- min / hour alreadyhave been provided properly ... --->
	<cfif Hour(a_dt_created) GT 0 OR Minute(a_dt_created) GT 0>
		<cfset form.FRMDT_CREATED_TIME_HOUR = Hour(a_dt_created) />
		<cfset form.FRMDT_CREATED_TIME_MINUTE = Minute(a_dt_created) />
	</cfif>
<cfelse>
	<!--- default = now ... --->
	<cfset a_dt_created = Now() />
</cfif>

<cfset a_dt_created = CreateDateTime(Year(a_dt_created), Month(a_dt_created), Day(a_dt_created), form.frmdt_created_time_hour, form.frmdt_created_time_minute, 0) />

<cfinvoke component="#application.components.cmp_crmsales#" method="CreateHistoryItem" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="servicekey" value="#form.frmservicekey#">
	<cfinvokeargument name="objectkey" value="#form.frmobjectkey#">
	<cfinvokeargument name="subject" value="#form.frmsubject#">
	<cfinvokeargument name="projectkey" value="#form.frmprojectkey#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
	<cfinvokeargument name="dt_created" value="#a_dt_created#">
	<cfinvokeargument name="item_type" value="3">
	<cfinvokeargument name="linked_servicekey" value="#form.frmlinked_servicekey#">
	<cfinvokeargument name="linked_objectkey" value="#form.frmlinked_objectkey#">
</cfinvoke>

<!--- check result ... --->
<cfif stReturn.result>
	Done.
<cfelse>

</cfif>

