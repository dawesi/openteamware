<!--- //

	Cmp:		Lang
	Fn:			LoadTranslationData
	Description:Load translation data from DB and cache in app scope
	
	Header:		

// --->


<cfquery name="q_select_translation_data">
SELECT
	entryid,entryvalue
FROM
	langdata 
WHERE
	langno = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.langno#">
;
</cfquery>

