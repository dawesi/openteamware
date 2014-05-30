<!--- //

	Module:		CRMSales
	Function:	UpdateActivityCountOfContact
	Description:Update count of open activities on contact
	
// --->

<cfswitch expression="#arguments.itemtype#">

	<cfcase value="followups">
	
		<!--- get number of open followup items ... --->
		<cfquery name="q_select_open_followups" datasource="#request.a_str_db_tools#">
		SELECT
			COUNT(entrykey) AS count_id
		FROM
			followups
		WHERE
			objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
			AND
			servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
			AND
			done = 0
		;
		</cfquery>
		<!--- 
		<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="q_select_open_followups" type="html"><cfdump var="#q_select_open_followups#"></cfmail>
		 --->
		<cfset a_int_number_followups = val(q_select_open_followups.count_id) />
		
		<cfquery name="q_update_followup_index">
		UPDATE
			addressbook
		SET
			activity_count_followups = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(a_int_number_followups)#">
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
		;
		</cfquery>
	
	
	</cfcase>
	
	<cfcase value="appointments">
	
		<!--- update the number of open appointments ... --->
		<cfquery name="q_select_open_appointments" datasource="#request.a_str_db_tools#">
		SELECT
			meetingmembers.id,
			calendar.entrykey,
			calendar.date_start
		FROM
			meetingmembers
		LEFT JOIN calendar ON
			(calendar.entrykey = meetingmembers.eventkey)
		WHERE
			(meetingmembers.parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">)
			AND
			(meetingmembers.type = 1)
			AND NOT
			(calendar.entrykey = '')
			AND
			(calendar.date_start > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">)
		;
		</cfquery>

		<cfset a_int_number_appointments = q_select_open_appointments.recordcount />
		
		<cfquery name="q_update_appointments_index" datasource="#request.a_str_db_tools#">
		UPDATE
			addressbook
		SET
			activity_count_appointments = <cfqueryparam cfsqltype="cf_sql_integer" value="#Val(a_int_number_appointments)#">
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
		;
		</cfquery>
	
	</cfcase>
	
	<cfcase value="projects_0">
		<!--- common projects ... --->
		
	
	</cfcase>


</cfswitch>