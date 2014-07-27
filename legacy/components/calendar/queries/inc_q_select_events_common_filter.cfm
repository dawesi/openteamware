<!--- //

	Module:		Import
	Function:	GetEventsFromTo
	Description:Work with some common filters ...
	

// --->

(1 = 1)

<!--- query for entrykey ... column name is EVENTKEY (because to make the column unique in the big UNION statement ... --->
<cfif StructKeyExists(arguments.filter, 'entrykeys') AND Len(arguments.filter.entrykeys) GT 0>
	AND
	(calendar_collect.eventkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="yes">))
</cfif>

<!--- filter for certain virtual calendars ? ... --->
<cfif StructKeyExists(arguments.filter, 'virtualcalendars') and Len(arguments.filter.virtualcalendars) GT 0 >

    <cfset a_str_virtualcalendarkeys = arguments.filter.virtualcalendars />
	
    AND (
    <cfset a_int_default_index = ListContainsNoCase(a_str_virtualcalendarkeys, 'default')>
    
	<cfif a_int_default_index NEQ 0>
        <cfset a_str_virtualcalendarkeys = ListDeleteAt(a_str_virtualcalendarkeys, a_int_default_index)>
        calendar_collect.virtualcalendarkey = ''
    </cfif>
    
	<cfif Len(a_str_virtualcalendarkeys) GT 0>
        <cfif a_int_default_index NEQ 0>
            OR
        </cfif>
        calendar_collect.virtualcalendarkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_virtualcalendarkeys#" list="yes">)
    </cfif>
    
	)
	
</cfif>	

