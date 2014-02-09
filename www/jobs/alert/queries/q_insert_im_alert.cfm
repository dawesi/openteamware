<cfparam name="InsertIMAlertRequest.Recipient" type="string">
<cfparam name="InsertIMAlertRequest.Message" type="string">

<cfquery name="q_insert_im_alert" datasource="#request.a_str_db_tools#">
INSERT INTO
	im_alerts_2send
	(
	recipient,
	msg
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertIMAlertRequest.Recipient#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertIMAlertRequest.Message#">
	)
;
</cfquery>