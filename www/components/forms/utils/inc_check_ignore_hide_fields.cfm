<!--- //

	Module:		Forms
	Function:	DisplaySavedForm
	Description:Remove ignore fields, display fields, hide fields based on parameters to function
	
	Header:		

// --->

<!--- disable fields by entrykey ... --->
<cfif Len(arguments.entrykeys_fields_to_ignore) GT 0>
	<cfquery name="q_select_fields" dbtype="query">
	SELECT
		*
	FROM
		q_select_fields
	WHERE
		entrykey NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys_fields_to_ignore#" list="true">)
	;
	</cfquery>
</cfif>

<!--- ignore fields by database fieldname ... --->
<cfif Len(arguments.dbfieldnames_to_ignore) GT 0>

	<cfquery name="q_select_fields_to_remove" dbtype="query">
	SELECT
		entrykey
	FROM
		q_select_fields
	WHERE
		(UPPER(db_fieldname) IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.dbfieldnames_to_ignore)#" list="true">))
	
	<cfif Len(arguments.entrykeys_fields_force_to_show) GT 0>
		AND NOT
		(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys_fields_force_to_show#" list="true">))	
	</cfif>
	
	;
	</cfquery>
	
	<cfif q_select_fields_to_remove.recordcount GT 0>
	
	<cfquery name="q_select_fields" dbtype="query">
	SELECT
		*
	FROM
		q_select_fields
	WHERE
		NOT
		(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_fields_to_remove.entrykey)#" list="true">))	
	;
	</cfquery>
	
	</cfif>
	
</cfif>

<!--- force to show certain fields by entrykey ... --->
<cfif Len(arguments.entrykeys_fields_force_to_show) GT 0>
	<cfloop query="q_select_fields">
		
		<cfif ListFindNoCase(arguments.entrykeys_fields_force_to_show, q_select_fields.entrykey) GT 0>
		
			<cfset tmp = QuerySetCell(q_select_fields, 'ignorebydefault', 0, q_select_fields.currentrow) />
		
		</cfif>
		
	</cfloop>
</cfif>

<cfquery name="q_select_fields" dbtype="query">
SELECT
	*
FROM
	q_select_fields
WHERE
	ignorebydefault = 0
;
</cfquery>


