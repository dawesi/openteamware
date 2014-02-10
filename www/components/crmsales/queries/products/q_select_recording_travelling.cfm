<!--- //
	Module:		 Extras
	Description: Displays records from table mycrm.travellingkilometers
	

	
// --->

<cfquery name="q_select_recording_travelling" datasource="#request.a_str_db_crm#">
SELECT 
    
	entrykey,
	dt_added,
	createdbyuserkey,
	<cfif arguments.useinreport>
		NULL AS username,
	</cfif>
	kilometers
FROM 
	travellingkilometers
WHERE
	1 = 1
	<!--- <cfif NOT arguments.useinreport> --->
		AND
    	createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>
	<!--- </cfif> --->
	<cfif StructKeyExists(arguments.filter, 'dt_start_date')>
    AND
    dt_added >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.filter.dt_start_date#"/>
    </cfif>
    <cfif StructKeyExists(arguments.filter, 'dt_end_date')>
	AND
	dt_added <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.filter.dt_end_date#"/>
	</cfif>
ORDER BY dt_added desc;
</cfquery>

<!--- //
 $Log: q_select_recording_travelling.cfm,v $
 Revision 1.6  2007-10-11 18:23:43  hansjp
 *** empty log message ***

 Revision 1.5  2007-08-02 13:17:30  jarok
 header and footer added

// --->
