<!--- //

	edit an event ...
	
	// --->
	
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>
	
<cfinvoke component="#application.components.cmp_calendar#" method="CleanUpAndCloneMeetingMembers">
	<cfinvokeargument name="eventkey" value="#url.entrykey#">
</cfinvoke>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cal_wd_caption_edit'))>

<cfif NOT stReturn.rights.edit>
	<h4>No Permissions to edit this item.</h4>
	<cfexit method="exittemplate">
</cfif>

<cfset NewOrEditEvent = StructNew() />
<cfset Variables.NewOrEditEvent.action = 'edit' />
<cfset Variables.NewOrEditEvent.redirect = ReturnRedirectURL() />
<cfset Variables.NewOrEditEvent.Query = stReturn.q_select_event />

<cfinclude template="dsp_inc_neworedit_event.cfm">