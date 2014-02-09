<cfparam name="url.jobkey" type="string" default="">

<cfquery name="q_select_status" datasource="#request.a_str_db_tools#">
DELETE FROM
	securemail_jobinfo
WHERE
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.jobkey#">
;
</cfquery>