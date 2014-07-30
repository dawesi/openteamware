<!--- //

	Component:	Follow Ups
	Function:	GetFollowUps
	Description:Load follow ups
	

// --->

<cfquery name="q_select_follow_ups">
SELECT
	createdbyuserkey,
	comment,
	userkey,
	dt_created,
	servicekey,
	objectkey,
	objecttitle,
	categories,
	dt_due,
	subject,
	done,
	entrykey,
	followuptype,
	priority,
	dt_created,
	alert_email
FROM
	followups
WHERE
	(1 = 1)
	
	<cfif StructCount(arguments.filter) GT 0>
	
		<cfif StructKeyExists(arguments.filter, 'entrykey')>
		AND
		(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykey#">)
		</cfif>	
		
		<cfif StructKeyExists(arguments.filter, 'userkey')>
		AND
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userkey#">)
		</cfif>
		
		<cfif StructKeyExists(arguments.filter, 'not_userkey')>
		AND NOT
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.not_userkey#">)
		</cfif>		
		
		<cfif StructKeyExists(arguments.filter, 'createdbyuserkey')>
		AND
		(createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.createdbyuserkey#">)
		</cfif>		
		
		<cfif StructKeyExists(arguments.filter, 'servicekey')>
		AND
		(servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">)
		</cfif>
		
		<cfif StructKeyExists(arguments.filter, 'objectkeys') AND arguments.filter.objectkeys NEQ ''>
		AND
		(objectkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.objectkeys#" list="yes">))
		</cfif>
		
		<cfif StructKeyExists(arguments.filter, 'done')>
		AND
		(done = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.done#">)
		</cfif>
		
		<cfif StructkeyExists(arguments.filter, 'dt_due') AND IsDate(arguments.filter.dt_due)>
		AND
		(DATE_FORMAT(dt_due, '%Y%m%d') = <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(arguments.filter.dt_due, 'yyyymmdd')#">)
		</cfif>
		
		<cfif StructkeyExists(arguments.filter, 'maxdate')>
		AND
		(dt_due < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.filter.maxdate)#">)
		</cfif>
		
		<!--- todo: Implement minus type --->
		<cfif StructkeyExists(arguments.filter, 'type')>
		AND
		(followuptype IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.filter.type#">))
		</cfif>	
		
		<cfif StructkeyExists(arguments.filter, 'not_type')>
		AND NOT
		(followuptype IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.filter.not_type#">))
		</cfif>				
		
	<cfelse>
		<!--- default ... --->
		AND
		objectkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkeys#" list="yes">)
	</cfif>	

ORDER BY
	dt_due
;
</cfquery>


