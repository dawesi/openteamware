<!--- //
	Module:		 Calendar
	Description: selects meetingmember records for specified event key(s) (entrykey or entrykeys in arguments scope)
// --->

<cfquery name="q_select_meeting_members">
SELECT
	type,parameter,status,dt_answered,comment,sendinvitation
FROM
	meetingmembers
WHERE
    <cfif StructKeyExists(arguments, 'temporary') AND arguments.temporary>
        temporary = 1
    <cfelse>
        temporary = 0
    </cfif>
    AND
	<cfif StructKeyExists(arguments, 'entrykeys') AND Len(arguments.entrykeys) GT 0>
		<!--- multiple keys --->
		eventkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#" list="yes">)
	<cfelse>
		eventkey  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	</cfif>	
;
</cfquery>


