


<cfquery name="q_check_entry"  >
SELECT
	count(id) AS count_id
FROM
	scenarioseen
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">)
	AND
	(pagesection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.section#">)
	AND
	(pagename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.page#">)
; 
</cfquery>