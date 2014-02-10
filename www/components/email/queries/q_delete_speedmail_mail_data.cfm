<!---<cftransaction action="begin">--->


<cfquery name="q_delete_speed_mail_data" datasource="#request.a_str_db_email#">
BEGIN;
DELETE FROM
	folderdata
WHERE
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.username)#">
	AND
	
	<cfif StructKeyExists(arguments, 'sourcefolder')>
		foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourcefolder#">
	<cfelse>
		foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	</cfif>
	
	AND
	uid IN
	
	<!--- use the given UID attribute ... UID or UIDS --->
	<cfif StructKeyExists(arguments, 'uids')>
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.uids#" list="yes">)
	<cfelse>
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.uid#" list="yes">)
	</cfif>
;
COMMIT;
</cfquery>