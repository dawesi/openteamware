<!--- //

	Module:		Calendar
	Function:	GetEventsFromTo	
	Description:Clone events
	

// --->

<cfloop query="q_select_events">
	<cfswitch expression="#q_select_events.repeat_type#">	

		<cfcase value="1">
		<!--- daily repeating ... add virtuall entries --->
		<!--- feststellen, ob dies �berhaupt notwendig ist ... 
		nur wichtig f�r daily und weekly events ... der rest kann nicht 2x in 
		einer ansicht vorkommen --->
		
		<!--- termin hinten hinzuf�gen --->
		<!--- indexloop nach tagen --->
		
		<!--- calculate the end date ... maybe given, maybe not (in this case CalQuery.aEndDate)
			  use the default end date if no end date is given or if the real
			  end date is beyond the desired end date
			 --->
			 
		<cfif (isDate(q_select_events.repeat_until) is false) OR
		      (q_select_events.repeat_until gt arguments.enddate)>
			<cfset a_dt_until = arguments.enddate />
		<cfelse>
			<cfset a_dt_until = DateAdd('n', 5, q_select_events.repeat_until) />
		</cfif>
		
		
		
		<!--- check if the right month (important for the loop below) has been taken --->
		<!--- if the start state is below the desired display start date use this date -
			otherwise the set start date --->
		<cfif q_select_events.date_start LT arguments.startdate>	
			<cfset a_dt_start_date = arguments.startdate />
		<cfelse>
			<cfset a_dt_start_date = q_select_events.date_start />
		</cfif>
		
				
		<!--- difference from start date until "UNTIL" --->
		<cfset a_int_hours_diff = DateDiff('h',  a_dt_start_date, a_dt_until) />
		<cfset a_int_diff = Ceiling(a_int_hours_diff/24) />
		
		<!--- loop now the days from begin to end ... --->
			
		<cfloop index="ii_day" from="0" to="#a_int_diff#">
				
			<cfset a_dt_RecurDailyTmpDate = DateAdd('d', ii_day, a_dt_start_date)>
			
			<cfif a_dt_RecurDailyTmpDate LTE a_dt_until>
												
			<cfset a_bol_recur_found = false />
						
			<!---<cfif Evaluate("q_select_events.repeat_day_"&DayOfWeek(a_dt_RecurDailyTmpDate)) is 1>--->
			<cfif q_select_events["repeat_day_"&DayOfWeek(a_dt_RecurDailyTmpDate)][q_select_events.currentrow] is 1>

				<cfset ARecurFound = True />
				
				<!-- hit - event clonen! --->
				<cfset a_int_days_diff = DateDiff("d", q_select_events.date_start, a_dt_RecurDailyTmpDate)+1 />
				<cfset a_int_hours_diff = DateDiff('h', q_select_events.date_start, a_dt_RecurDailyTmpDate) /> 
				
				<cfset a_int_days_diff = Ceiling(a_int_hours_diff/24) />
				
				<!--- important:
				
					if the start date is smaller than the arguments startdate, subtract 1 day 
					
					!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					--->
				<cfif q_select_events.date_start LT arguments.startdate>
					<cfset a_int_days_diff = a_int_days_diff - 1 />
				</cfif>
				
				<cfif a_int_days_diff gt 0>
					<cfset EventCloneRequest.DayDiff = a_int_days_diff />
					<cfinclude template="inc_clone_event.cfm">

				</cfif>
			</cfif>
			
			</cfif>
		</cfloop>		
		</cfcase>
	
		<cfcase value="2">
			<!--- // weekly repeating event // --->
		
			<!--- calculate the end date ... maybe given, maybe not (in this case CalQuery.aEndDate --->
			<cfscript>
				if ((isDate(q_select_events.repeat_until) is false) OR (q_select_events.repeat_until GT arguments.enddate)) 
					{
					a_dt_until = arguments.enddate;
					}
					else
						{
						a_dt_until = q_select_events.repeat_until;
						}
				if (q_select_events.date_start LT arguments.startdate)
					{
					A_dt_start_date = arguments.startdate;
					}
					else
						{
						A_dt_start_date = q_select_events.date_start;
						}	
						
				A_int_diff = DateDiff("d", A_dt_start_date, a_dt_until)+1;	
			</cfscript>
			
				
		
			<cfloop index="ii_day" from="0" to="#(A_int_diff+1)#">
				<cfset a_dt_tmp_weekly_repeat_date = DateAdd('d', ii_day, A_dt_start_date) />
					
				<cfif Compare(DayOfWeek(a_dt_tmp_weekly_repeat_date), q_select_events.repeat_weekday) IS 0>
					<!--- add the days PLUS one --->
					
					<cfset A_int_days_diff = DateDiff('d', q_select_events.date_start, a_dt_tmp_weekly_repeat_date)>
					
					<cfif A_int_days_diff gt 0>
						<cfset EventCloneRequest.DayDiff = A_int_days_diff>
						
						<!--- if hour is zuero --->
						<cfif Hour(q_select_events.date_start) IS 0>
							<cfset EventCloneRequest.DayDiff = EventCloneRequest.DayDiff + 1>
						</cfif>
						
						<cflog text="q_select_events.title: #q_select_events.title#" type="Information" log="Application" file="ib_cal_recur">
						<cflog text="A_int_days_diff: #A_int_days_diff#" type="Information" log="Application" file="ib_cal_recur">
						<cfinclude template="inc_clone_event.cfm">
					</cfif>				
				</cfif>
				
			</cfloop>		
		</cfcase>
		
		<cfcase value="3">
		<!--- monthly repeating ... --->
		<cfif (isDate(q_select_events.repeat_until) is false) OR
		      (q_select_events.repeat_until gt arguments.startdate)>
			<!--- set end date to end date of display --->
			<cfset a_dt_until = arguments.enddate>
		<cfelse>
			<!--- set end to given end --->
			<cfset a_dt_until = q_select_events.repeat_until>
		</cfif>
		
		<cfif q_select_events.date_start lt arguments.startdate>
			<cfset A_dt_start_date = arguments.startdate>
		<cfelse>
			<cfset A_dt_start_date = q_select_events.date_start>
		</cfif>		
		
		<cfset A_int_diff = DateDiff('d', A_dt_start_date, A_dt_until)+1>
		
		<cfloop index="A_int_index_DayII" from="1" to="#A_int_diff#">
			<cfset a_dt_tmp_monthly_repeat_date = DateAdd('d', A_int_index_DayII, A_dt_start_date)>

			<cfif Day(a_dt_tmp_monthly_repeat_date) is Day(q_select_events.date_start)>
				<!--- add the days PLUS one --->			
				<cfset A_int_days_diff = DateDiff("d", q_select_events.date_start, a_dt_tmp_monthly_repeat_date)>
				
				<cfif A_int_days_diff gt 0>
					<cfset EventCloneRequest.DayDiff = A_int_days_diff>
					<cfinclude template="inc_clone_event.cfm">
				</cfif>
			</cfif>
			
		</cfloop>
		
		</cfcase>
		
		<cfcase value="4">
		<!--- yearly --->
		<cfif (isDate(q_select_events.repeat_until) is false) OR (q_select_events.repeat_until gt arguments.enddate)>
			<cfset A_dt_Until = arguments.enddate>
		<cfelse>
			<cfset A_dt_until = q_select_events.repeat_until>
		</cfif>
		
		<cfif q_select_events.date_start LT arguments.startdate>	
			<cfset A_dt_start_date = arguments.startdate>
		<cfelse>
			<cfset A_dt_start_date = q_select_events.date_start>
		</cfif>
		
		<cfset A_int_diff = DateDiff("d", A_dt_start_date, A_dt_until)+1>
		
		<cfloop index="A_int_index_DayII" from="1" to="#A_int_diff#">
			
			<cfset a_dt_tmp_yearly_repeat_date = DateAdd("d", A_int_index_DayII, A_dt_start_date)>

			<cfif (Day(a_dt_tmp_yearly_repeat_date) is Day(q_select_events.date_start)) AND
				  (Month(a_dt_tmp_yearly_repeat_date) is Month(q_select_events.date_start))>
				<!--- add the days PLUS one --->			
				<cfset A_int_days_diff = DateDiff("d", q_select_events.date_start, a_dt_tmp_yearly_repeat_date)>
				<cfset EventCloneRequest.DayDiff = A_int_days_diff>
				<cfinclude template="inc_clone_event.cfm">
			</cfif>
		
		</cfloop>
		
		
		</cfcase>
	</cfswitch>
</cfloop>
