<cfquery name="q_select_user_is_admin">
SELECT
	companycontacts.companykey,companycontacts.contacttype,companycontacts.user_level,companies.companyname,companies.countryisocode
FROM
	companycontacts
LEFT JOIN
	companies ON (companycontacts.companykey = companies.entrykey) 
WHERE
	(companycontacts.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
	
	<cfif Len(arguments.companykey) GT 0>
	AND
	(companycontacts.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">)
	</cfif>
; 
</cfquery>