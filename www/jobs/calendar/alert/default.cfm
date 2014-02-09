<!--- //

	Module:		Framework/Jobs
	Description:Send calendar alert
	

// --->


<cfinclude template="/common/app/app_global.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<!--- select all events ... --->

<cfset a_dt_now = GetUTCTime(now())>

<cfquery name="q_select_open_alerts" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,userkey,eventkey,dt_remind,type,remind_email_adr,eventtitle,eventstart
FROM
	cal_remind
WHERE
	status = 0
	AND
	<!--- SELECT email and SMS; reminder application handles this itself --->
	type IN (0,1)
	AND
	dt_remind < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(a_dt_now)#">
ORDER BY
	dt_remind
;
</cfquery>

<cfdump var="#q_select_open_alerts#">
<cfoutput query="q_select_open_alerts">

	
	<cfswitch expression="#q_select_open_alerts.type#">
		<cfcase value="0">
		<!--- email ... --->
		<cfinclude template="inc_alert_mail.cfm">
		</cfcase>
		<cfcase value="1">
		<!--- SMS --->
		<cfinclude template="inc_send_sms.cfm">
		</cfcase>
	
	</cfswitch>

	<!--- set status to done ... --->
	<cfquery name="q_update" datasource="#request.a_str_db_tools#">
	UPDATE
		cal_remind
	SET
		status = 1
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_open_alerts.entrykey#">
	;
	</cfquery>

</cfoutput>


