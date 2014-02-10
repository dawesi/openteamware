<cfif StructKeyExists(arguments.filter, 'virtualcalendarkey') AND
	  (Len(arguments.filter.virtualcalendarkey) GT 0)>
	AND
	(calendar.virtualcalendarkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.virtualcalendarkey#" list="true">))
</cfif>