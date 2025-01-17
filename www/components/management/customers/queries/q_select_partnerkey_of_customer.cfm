<cfquery name="q_select_partnerkey_of_customer">
SELECT
	<cfswitch expression="#arguments.partnertype#">
		<cfcase value="distributor">
			distributorkey
		</cfcase>
		<cfdefaultcase>
			resellerkey
		</cfdefaultcase>
	</cfswitch>
	AS partnerkey
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>