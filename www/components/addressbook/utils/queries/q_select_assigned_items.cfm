<cfquery name="q_select_assigned_items">
SELECT
	objectkey
FROM
	assigned_items
WHERE
	(servicekey = '52227624-9DAA-05E9-0892A27198268072')
	AND
	(
		<cfif a_struct_filter_element.operator IS 1>
			NOT
		</cfif>
		
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_filter_element.comparevalue#">)
		
	)
;
</cfquery>