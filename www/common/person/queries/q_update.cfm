<cfquery name="q_update"  datasource="#request.a_str_db_tools#">
UPDATE
	scenarioseen
SET
	timesseen = <cfqueryparam cfsqltype="cf_sql_integer" value="#acount#">,
	lastvisit = current_timestamp
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">)
	AND
	(pagesection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.section#">)
	AND
	(pagename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page#">)
; 
</cfquery>