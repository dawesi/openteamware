<!--- //

	save
	
	// --->
	
<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="form.frmalert_email" type="numeric" default="0">
<cfparam name="form.frmdt_time_hour" type="string" default="0">
<cfparam name="form.frmdt_time_minute" type="string" default="0">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cfabort>
</cfif>

<cfset a_dt_due = LsParseDateTime(form.frmdt)>

<cfif form.frmdt_time_hour NEQ 0>
	<!--- also add time information ... --->
	
	<cfset a_dt_due = DateAdd('h', val(form.frmdt_time_hour), a_dt_due)>
	<cfset a_dt_due = DateAdd('n', val(form.frmdt_time_minute), a_dt_due)>
	
</cfif>

<cfinvoke component="#request.a_str_component_followups#" method="CreateFollowup" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="servicekey" value="#form.frmservicekey#">
	<cfinvokeargument name="objectkey" value="#form.frmobjectkey#">	
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="dt_due" value="#a_dt_due#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
	<cfinvokeargument name="type" value="#form.frmtype#">
	<cfinvokeargument name="priority" value="#form.frmpriority#">
	<cfinvokeargument name="objecttitle" value="#form.frmtitle#">
	<cfinvokeargument name="alert_email" value="#form.frmalert_email#">
</cfinvoke>

<html>
	<head>
		<script type="text/javascript">
			function cw()
				{
				window.close();
				}
		</script>
	</head>
	<body onLoad="cw();">
	
	</body>
</html>