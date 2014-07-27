<cfquery name="q_select_highest_available_promocode" datasource="#request.a_str_db_users#">
SELECT
	codevalue,id
FROM
	assigned_promocodes 
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	deducted = 0
ORDER BY
	codevalue DESC
;
</cfquery>

<cfif q_select_highest_available_promocode.recordcount IS 0>
	<!--- no unused codes available ... --->
	<cfset a_int_return = 0>
	<cfexit method="exittemplate">
</cfif>


<!--- update --->
<cfquery name="q_update_set_used" datasource="#request.a_str_db_users#">
UPDATE
	assigned_promocodes
SET
	deducted = 1
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_highest_available_promocode.id#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<!--- return the codevalue ... --->
<cfset a_int_return = q_select_highest_available_promocode.codevalue>