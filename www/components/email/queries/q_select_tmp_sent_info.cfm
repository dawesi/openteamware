<!--- //

	Module:		Email
	Action:		GetSentMessageInformation
	Description: 
	

// --->

<cfquery name="q_select_tmp_sent_info" datasource="#request.a_str_db_tools#">
SELECT
	afrom,ato,subject,cc,bcc,destinationfolder,
	dt_created,smjobkey,sm_action,messageid,format,body
FROM
	sendmailtempinfo
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Entrykey#">
;
</cfquery>

