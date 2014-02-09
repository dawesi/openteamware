<!--- //

	select the email alert settings
	
	// --->
<cfparam name="SelectEmailAlertSettings.accountid" type="numeric" default="0">


<cfquery name="q_select_email_alert_settings" datasource="#request.a_str_db_users#">
SELECT emailaddress,enabled FROM newmailalerts WHERE
userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
AND accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectEmailAlertSettings.accountid#">
AND type = 30;
</cfquery>