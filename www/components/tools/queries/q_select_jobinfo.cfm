<cfquery name="q_select_jobinfo">
SELECT
	asigned,
	aencrypted,
	subject,
	afrom,
	ato,
	acc,
	abcc,
	hostsignerror,
	hotsigninfomsg,
	hotsignxml,
	jobtype
FROM
	securemail_jobinfo
WHERE
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">
;
</cfquery>