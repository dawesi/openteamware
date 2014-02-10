<!--- //
	Module:		 Extras
	Description: Count up all kilometers by condition
	

	
// --->

<cfquery name="q_select_recording_travel_total" datasource="#request.a_str_db_crm#">
SELECT
	SUM(kilometers) AS total
FROM 
	travellingkilometers
WHERE
    createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>
    <cfif StructKeyExists(arguments.filter, 'dt_start_date')>
    AND
    dt_added >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.filter.dt_start_date#"/>
    </cfif>
    <cfif StructKeyExists(arguments.filter, 'dt_end_date')>
	AND
	dt_added <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.filter.dt_end_date#"/>
	</cfif>
</cfquery>

<!--- //
 $Log: q_select_record_travel_total.cfm,v $
 Revision 1.5  2007-08-02 13:17:15  jarok
 header and footer added

// --->
