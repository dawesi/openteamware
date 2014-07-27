<cfquery name="q_select_product" datasource="#request.a_str_db_users#">
SELECT
	entrykey,
	productname,
	dt_created,
	description,
	productgroupkey,
	itemindex,
	ongoing,
	unit,
	allowownquantities
FROM
	products
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
;
</cfquery>