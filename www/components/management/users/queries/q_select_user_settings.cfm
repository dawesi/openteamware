<cfquery name="q_select_user_settings">
SELECT
	utcdiff,daylightsavinghours,charset,countryisocode,
	productkey,defaultlanguage
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>