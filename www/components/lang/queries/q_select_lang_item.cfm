<cfquery name="q_select_lang_item">
SELECT
	entryvalue
FROM
	langdata
WHERE
	(langno = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.langno#">)
	AND
	(entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entryid#">)
;
</cfquery>