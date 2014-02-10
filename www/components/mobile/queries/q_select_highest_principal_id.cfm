<cfquery name="q_select_highest_principal_id" datasource="#request.a_str_db_syncml#">
SELECT
	counter
FROM
	sync4j_id
WHERE
	idspace = 'principal'
;
</cfquery>