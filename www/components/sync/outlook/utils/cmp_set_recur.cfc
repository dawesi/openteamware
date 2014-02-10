<cfcomponent displayname="SetRecurringData" output='false'>

	<cffunction access="public" name="SetRecurrence" output="false" returntype="boolean">
		<cfargument name="structure" required="true" type="struct">
		<cfargument name="entrykey" type="string" required="true">
		
		<!--- calculate recurrencing events and insert --->
		<cfset var a_arr_return = 0 />
		<cfset var a_int_recurr_type = structure.recurrencetype>
		<cfset var a_str_end_date = structure.patternenddate>
		<cfset var ii = 0 />
		<cfset var q_update_recur = 0 />
		<cfset var a_dt_end_date = '' />
		<cfset var a_int_dayofmonth = structure.dayofmonth>
		<cfset var a_str_dayofweekmask = structure.dayofweekmask>
		
		<cfif Len(a_str_end_date) gt 0 AND IsDate(a_str_end_date)>
			<cfset a_dt_end_date = LsParseDateTime(a_str_end_date)>
		<cfelse>
			<!--- dummy value ... --->
			<cfset a_dt_end_date = ''>
		</cfif>
		
		
		
		<!--- calculate data and update calendar table --->
		
		<!--- 0 olRecursDaily  Interval Alle N Tage 
					DayOfWeekMask Jeden Dienstag, Mittwoch und Donnerstag 
				2 olRecursMonthly  Interval Alle N Monate 
					DayOfMonth Der N-te Tag im Monat 
				3 olRecursMonthNth  Interval Alle N Monate 
					Instance Der N-te Dienstag 
					DayOfWeekMask Jeden Dienstag und Mittwoch 
				1 olRecursWeekly  Interval Alle N Wochen 
					DayOfWeekMask Jeden Dienstag, Mittwoch und Donnerstag 
				5 olRecursYearly  DayOfMonth Der N-te Tag im Monat 
					MonthOfYear Februar 
				6 olRecursYearN-te  Instance Der N-te Dienstag 
					DayOfWeekMask Dienstag, Mittwoch, Donnerstag 
					MonthOfYear Februar 
		--->
		
		<cfswitch expression="#structure.recurrencetype#">
			<cfcase value="0">
			<!--- daily ... ableiten von DayOfWeekMask --->
			
			<!--- mo - so --->
			<cfquery datasource="#request.a_str_db_tools#" name="q_update_recur">
			UPDATE
				calendar
			SET
				repeat_type = 1,
				repeat_start = date_start,
				repeat_day_1 = 1,
				repeat_day_2 = 1,
				repeat_day_3 = 1,
				repeat_day_4 = 1,
				repeat_day_5 = 1,
				repeat_day_6 = 1,
				repeat_day_7 = 1,
				
				<cfif IsDate(a_dt_end_date)>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_end_date)#">
				<cfelse>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
				</cfif>
			WHERE
				(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
			;
			</cfquery>
			
			</cfcase>
			<cfcase value="1">
			<!--- weekly --->
			<cfset a_arr_return = GetDaysFromMask(a_str_dayofweekmask)>
			
			<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="array">
			<cfloop from="1" to="#arraylen(a_arr_return)#" index="ii">
			#a_arr_return[ii]#
			</cfloop>
			</cfmail>--->
			
			<!--- more or less also a weekly repeatment --->
			<cfquery datasource="#request.a_str_db_tools#" name="q_update_recur">
			UPDATE
				calendar
			SET
				repeat_type = 1,
				repeat_start = date_start,
				repeat_day_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[1]#">,
				repeat_day_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[2]#">,
				repeat_day_3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[3]#">,
				repeat_day_4 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[4]#">,
				repeat_day_5 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[5]#">,
				repeat_day_6 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[6]#">,
				repeat_day_7 = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_arr_return[7]#">,

				<cfif IsDate(a_dt_end_date)>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_end_date)#">
				<cfelse>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
				</cfif>
				
			WHERE
				(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
			;
			</cfquery>			
			
			</cfcase>			
			<cfcase value="2">
			<!--- monthly --->
			
			<cfquery datasource="#request.a_str_db_tools#" name="q_update_recur">
			UPDATE
				calendar
			SET
				repeat_type = 3,
				repeat_start = date_start,
				repeat_day = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_dayofmonth#">,
				repeat_month = month(date_start),

				<cfif IsDate(a_dt_end_date)>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_end_date)#">
				<cfelse>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
				</cfif>
				
			WHERE
				(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
			;
			</cfquery>
			
			</cfcase>
			<cfcase value="5">
			<!--- yearly --->
			
			<cfquery datasource="#request.a_str_db_tools#" name="q_update_recur">
			UPDATE
				calendar
			SET
				repeat_type = 4,
				repeat_start = date_start,
				repeat_day = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_dayofmonth#">,
				repeat_month = month(date_start),
				
				<cfif IsDate(a_dt_end_date)>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_end_date)#">
				<cfelse>
				repeat_until = <cfqueryparam cfsqltype="cf_sql_timestamp" null="yes">
				</cfif>
				
			WHERE
				(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
			;
			</cfquery>			
			
			</cfcase>
		
		</cfswitch>
			
		<cfreturn true>
	
	</cffunction>

	<!--- extract days ... --->	
	<cffunction access="private" name="GetDaysFromMask" returntype="array">
		<cfargument name="DaysMask" type="numeric" default="" required="true">
		
		<cfset var a_int_days = arguments.daysmask>

		<!--- create the return array --->
		<cfset var a_arr_return = ArrayNew(1)>
		<cfset var tmp = ArraySet(a_arr_return, 1, 7, "0")>
		
		<!--- olSunday(1), olMonday(2), olTuesday(4), olWednesday(8), olThursday(16),
			olFriday(32) oder olSaturday(64). --->
		
		<!--- return days divided by a comma --->
		<cfif a_int_days gte 64>
			<!--- saturday --->
			<cfset a_arr_return[7] = 1>
			<cfset a_int_days = a_int_days - 64>
		</cfif>
		
		<cfif a_int_days gte 32>
			<!--- friday --->
			<cfset a_arr_return[6] = 1>
			<cfset a_int_days = a_int_days - 32>
		</cfif>
		
		<cfif a_int_days gte 16>
			<!--- thursday --->
			<cfset a_arr_return[5] = 1>
			<cfset a_int_days = a_int_days - 16>
		</cfif>
		
		<cfif a_int_days gte 8>
			<!--- wednesday --->
			<cfset a_arr_return[4] = 1>
			<cfset a_int_days = a_int_days - 8>
		</cfif>
		
		<cfif a_int_days gte 4>
			<!--- tuesday --->
			<cfset a_arr_return[3] = 1>
			<cfset a_int_days = a_int_days - 4>
		</cfif>
		
		<cfif a_int_days gte 2>
			<!--- monday --->
			<cfset a_arr_return[2] = 1>
			<cfset a_int_days = a_int_days - 2>
		</cfif>
		
		<cfif a_int_days gte 1>
			<!--- sunday --->
			<cfset a_arr_return[1] = 1>
			<cfset a_int_days = a_int_days - 1>
		</cfif>
		
		<cfreturn a_arr_return>
	</cffunction>
</cfcomponent>