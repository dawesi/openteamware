<cftry>
<cfquery name="q_mailspeed_empty_folder" datasource="#request.a_str_db_email#">
DELETE FROM
	folderdata
WHERE
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	AND
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>

<cfcatch type="any">

</cfcatch>
</cftry>