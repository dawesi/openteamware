<cfset request.a_bol_events_filtered = false>

<cfset a_str_display_private_events = ''>

<cfif request.a_bol_display_show_private_events IS FALSE>
	<!--- remove private entries ... --->
	<cfset request.a_bol_events_filtered = true>
	
	<!--- select all non-private events ... --->
	<cfquery name="q_select_events" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		(privateevent = 0)
		AND NOT
		(workgroupkeys IS NULL)
	;
	</cfquery>
	
	<cfset a_str_display_private_events = ValueList(q_select_events.entrykey)>
	
<cfelse>

	<cfset a_str_display_private_events = ''>
	<!--- select all private events ... --->
	<cfloop query="q_select_events">
		<cfif q_select_events.privateevent IS 1 OR
			  Len(q_select_events.workgroupkeys) IS 0>			  
		
			  <!--- further check: check if user has to take part (is meeting member) --->
			  <cfset a_str_display_private_events = ListPrepend(a_str_display_private_events, q_select_events.entrykey)>
		
		</cfif>
	</cfloop>
		
</cfif>

<!--- create the two lists and sort them for proper comparing ... --->
<cfset a_str_list1 = ListSort(ValueList(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key), 'text')>
<cfset a_str_list2 = ListSort(request.a_str_display_show_workgroup_events, 'text')>

<cfif Compare(a_str_list1, a_str_list2) NEQ 0>
	<!--- display not all workgroup items! --->
	<cfset a_str_delete_rows = ''>
	
	<!--- loop through the events ... --->
	<cfloop query="q_select_events">
	
		<cftry>
	
		<cfset a_bol_found = false>
		
		<!--- is this an event listed in the private section= --->
		<cfif (ListFind(a_str_display_private_events, q_select_events.entrykey) GT 0)>
			<cfthrow type="continue">
		</cfif>
		
		<cfif len(request.a_str_display_show_workgroup_events) GT 0>
	
			<!--- check if workgroupkey is in the list --->
			<cfloop list="#request.a_str_display_show_workgroup_events#" delimiters="," index="a_str_workgroup_key">
			
				<!--- hit ... --->
				<cfif (ListFind(q_select_events.workgroupkeys, a_str_workgroup_key) GT 0)>								
					<cfthrow type="continue">				
				</cfif>
			
			</cfloop>
			
		<cfelse>
			<!--- check if we've got at least a simple private item ... --->
			<cfif ListFind(a_str_display_private_events, q_select_events.entrykey) GT 0>
				<cfthrow type="continue">
			</cfif>
		</cfif>
		
		<cfset a_str_delete_rows = ListPrepend(a_str_delete_rows, q_select_events.currentrow)>
		
		<cfcatch type="continue"></cfcatch>
		</cftry>
		
	</cfloop>
	
	
	<cfif Len(a_str_delete_rows) GT 0>
		<!--- remove the desired rows ... --->
		<cfset q_select_events = QueryDeleteRows(q_select_events, a_str_delete_rows)>
		
		<!--- yes, we're filtering ... --->
		<cfset request.a_bol_events_filtered = true>
	</cfif>
		
</cfif>

<cfset a_str_list_display_events = ValueList(q_select_events.entrykey)>

<cfif stReturn.q_select_events.recordcount GT 0>

	<cfquery name="q_select_whole_day_events" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		(
			(int_start_num = #DateFormat(request.a_dt_current_date, 'yyyymmdd')#0000)
			OR
			(int_start_num = #DateFormat(request.a_dt_current_date, 'yyyymmdd')#0100)
		)
		AND
		(dt_duration = 1000000)
	;
	</cfquery>

	<cfquery name="q_select_events_before" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		(int_start_num < #a_int_dt_before#)
		AND
		(dt_duration <> 1000000)
	ORDER BY
		date_start
	;
	</cfquery>

	<cfquery name="q_select_events_main" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		int_start_num >= #a_int_dt_before#
		AND
		int_start_num <= #a_int_dt_afterwards#
	ORDER BY
		date_start
	;
	</cfquery>
	
	<cfquery name="q_select_events_afterwards" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		int_start_num >= #a_int_dt_afterwards#
		<!---AND
		int_start_num <= #a_int_dt_dayend#--->
	ORDER BY
		date_start
	;
	</cfquery>
	
	<cfquery name="q_select_next_day_events" dbtype="query">
	SELECT
		*
	FROM
		q_select_events
	WHERE
		int_start_num >= #a_int_dt_dayend#
	;
	</cfquery>	
<cfelse>
	<cfset q_select_events_before = QueryNew('entrykey')>
	<cfset q_select_events_main = QueryNew('entrykey')>
	<cfset q_select_events_afterwards = QueryNew('entrykey')>
	<cfset q_select_next_day_events = QueryNew('entrykey')>
	<cfset q_select_whole_day_events = QueryNew('entrykey')>	
</cfif>