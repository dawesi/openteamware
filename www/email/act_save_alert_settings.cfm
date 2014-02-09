<!--- //

	save all alert settings
	
	a) kill all existing entries
	
	b) save new ones
	
	// --->

<cfparam name="form.frmaccountid" default="0" type="numeric">
<cfparam name="form.frmsms_alerts_per_day" type="numeric" default="10">
<cfparam name="form.FRMNONIGHTALERTS" type="numeric" default="0">

<cfset DeleteAllExistingAlerts.accountid = form.frmaccountid>
<cfinclude template="queries/q_delete_existing_alerts.cfm">

<!--- SMS alert --->
<cfif isdefined("form.frmsms_alert_enabled")>

	<!--- insert --->
	<cfquery name="q_insert_sms_alert" datasource="#request.a_str_db_users#">
	INSERT INTO newmailalerts
	(userid,accountid,excludeadr,maxperday,enabled,type,nonightalerts)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmaccountid)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmadr_sms_no_alerts#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmsms_alerts_per_day)#">,
	1,
	10,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FRMNONIGHTALERTS#">);
	</cfquery>

</cfif>

<!--- e-mail --->
<cfif isdefined("form.frmemail_alert_enabled")>

	<!--- insert --->
	<cfquery name="q_insert_sms_alert" datasource="#request.a_str_db_users#">
	INSERT INTO newmailalerts
	(userid,accountid,emailaddress,enabled,type)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmaccountid)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmalertexternaladdress#">,
	1,
	30);
	</cfquery>

</cfif>


<cflocation addtoken="No" url="default.cfm?action=Alerts&accountid=#form.frmaccountid#">