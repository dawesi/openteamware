
<cfquery name="q_select_commissiongoods_history">
SELECT
	points,companykey,userkey,dt_created
FROM
	consumergoodshistory 
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	
	<cfif StructKeyExists(arguments, 'userkey') AND Len(arguments.userkey) GT 0>
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	</cfif>
ORDER BY
	id DESC
;
</cfquery>