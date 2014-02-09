
<cfquery name="q_select_events" datasource="#request.a_str_db_log#">
SELECT
	servicekey,objectkey,dt_created,actionname
FROM
	webservices_events
WHERE
	(applicationkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">)
	AND
	(clientkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientkey#">)
	AND
	(handlerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.handlerkey#">)
	AND
	(eventsent = 0)
	
	<!---<cfif StructKeyExists(arguments.filter, 'servicekey')>
		AND
		(servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.servicekey#">)
	</cfif>--->
	
;	
</cfquery>


<!--- update send = true --->