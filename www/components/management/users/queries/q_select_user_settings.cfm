<cfquery name="q_select_user_settings" datasource="#request.a_str_db_users#">
SELECT
	utcdiff,daylightsavinghours,mailcharset,charset,countryisocode,
	mailusertype,mailprofilekey,productkey,defaultlanguage
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>