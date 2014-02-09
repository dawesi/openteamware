<!--- //

	save
	
	// --->
	
<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="form.frmalert_email" type="numeric" default="0">
<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="form.frmreturnurl" type="string" default="">
<cfparam name="form.frmdt_time_hour" type="string" default="0">
<cfparam name="form.frmdt_time_minute" type="string" default="0">

<cfset a_struct_newvalues = StructNew()>
<cfset a_struct_newvalues.dt_due = LsParseDateTime(form.frmdt)>

<cfif form.frmdt_time_hour NEQ 0>
	<!--- also add time information ... --->
	
	<cfset a_struct_newvalues.dt_due = DateAdd('h', val(form.frmdt_time_hour), a_struct_newvalues.dt_due)>
	<cfset a_struct_newvalues.dt_due = DateAdd('n', val(form.frmdt_time_minute), a_struct_newvalues.dt_due)>
	
</cfif>

<cfset a_struct_newvalues.comment = form.frmcomment>
<cfset a_struct_newvalues.type = form.frmtype>
<cfset a_struct_newvalues.alert_email = form.frmalert_email>
<cfset a_struct_newvalues.priority = form.frmpriority>

<cfinvoke component="#request.a_str_component_followups#" method="UpdateFollowup" returnvariable="a_bol_return">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">				
	<cfinvokeargument name="newvalues" value="#a_struct_newvalues#">
</cfinvoke>

<cfif Len(form.frmreturnurl) GT 0>
	<cflocation addtoken="no" url="#form.frmreturnurl#">
<cfelse>
	<cflocation addtoken="no" url="/tools/followups/">
</cfif>