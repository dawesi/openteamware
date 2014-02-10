<!--- //

	Module:		Follow ups
	Function:	GetFollowup
	Description: 
	

// --->

<cfquery name="q_select_follow_up" datasource="#request.a_str_db_tools#">
SELECT
	createdbyuserkey,
	comment,
	userkey,
	dt_created,
	servicekey,
	objectkey,
	objecttitle,
	categories,
	dt_due,
	subject,
	done,
	entrykey,
	followuptype,
	priority,
	dt_created,
	alert_email
FROM
	followups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

