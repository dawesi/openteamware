

<cfquery name="q_select_faxlogo" datasource="#request.a_str_db_tools#">
SELECT
	imagedata,contenttype
FROM
	faxlogo
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>