<!--- //

	Module:		Import
	Function:	GetEventsFromTo
	Description:Define timeframe to include in calendar output ...
	

// --->

(
		
	(calendar.repeat_type > 0)
	
	AND
		(
			(calendar.repeat_until >= <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
				
			OR
			
			(calendar.repeat_until IS NULL)
				
			)
			
	AND NOT
		
			(calendar.date_start >= <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)

)

OR

(
	(calendar.repeat_type = 0)
	AND
	
	(

		(
			<!--- start in our timeframe --->
			(calendar.date_start >= <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
			AND
			(calendar.date_start < <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
		)
		
		OR
		
		(
			<!--- start and end before and after our timeframe --->
			(calendar.date_start < <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
			AND
			(calendar.date_end > <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
		)
		
		OR
		
		(
			<!--- end in our timeframe --->
			(calendar.date_end > <cfqueryparam value="#CreateOdbcDateTime(a_dt_start)#" cfsqltype="cf_sql_timestamp">)
			AND
			(calendar.date_end < <cfqueryparam value="#CreateOdbcDateTime(a_dt_end)#" cfsqltype="cf_sql_timestamp">)
		)
	)

)


