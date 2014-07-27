<cfset a_str_data_columns = ''>

<cfloop from="1" to="200" index="ii">
	<cfset a_str_data_columns = ListAppend(a_str_data_columns, 'data'&ii)>
</cfloop>

<cfset q_return = QueryNew('date_data_display,date_start,date_end,'&a_str_data_columns)>

<!--- how to proceed ... --->
<cfswitch expression="#arguments.interval#">
	<cfcase value="day">
		<cfset a_str_date_part = 'd'>
		<cfset a_int_diff = DateDiff('d', arguments.date_start, arguments.date_end)+1>
	</cfcase>
	<cfcase value="week">
		<cfset a_str_date_part = 'ww'>	
		<cfset a_int_diff = DateDiff('ww', arguments.date_start, arguments.date_end)+2>	
	</cfcase>
	<cfcase value="month">
		<cfset a_str_date_part = 'm'>	
		<cfset a_int_diff = DateDiff('m', arguments.date_start, arguments.date_end)+2>	
	</cfcase>
	<cfcase value="year">
		<cfset a_str_date_part = 'yyyy'>	
		<cfset a_int_diff = DateDiff('y', arguments.date_start, arguments.date_end)+2>
	</cfcase>
</cfswitch>


<cfloop from="1" to="#a_int_diff#" index="ii">
	<cfset QueryAddRow(q_return, 1)>
	<cfset a_dt_show = DateAdd(a_str_date_part, ii-1, arguments.date_start)>
	<cfswitch expression="#arguments.interval#">
		<cfcase value="day">
			<cfset QuerySetCell(q_return, 'date_data_display', DateFormat(a_dt_show, 'dd.mm.yy'), q_return.recordcount)>
		</cfcase>
		<cfcase value="week">
			<cfset QuerySetCell(q_return, 'date_data_display', 'W '&Week(a_dt_show), q_return.recordcount)>
		</cfcase>		
		<cfcase value="month">
			<cfset QuerySetCell(q_return, 'date_data_display', 'M '&LSDateFormat(a_dt_show, 'mmmm'), q_return.recordcount)>
		</cfcase>	
		<cfcase value="year">
			<cfset QuerySetCell(q_return, 'date_data_display', 'Y '&Year(a_dt_show), q_return.recordcount)>
		</cfcase>
	</cfswitch>
	
	<cfloop from="1" to="100" index="ii">
	<cfset QuerySetCell(q_return, 'data'&ii, 0, q_return.recordcount)>
	</cfloop>
	
	<cfset QuerySetCell(q_return, 'date_start', DateAdd(a_str_date_part, ii-1, arguments.date_start), q_return.recordcount)>
	<cfset QuerySetCell(q_return, 'date_end', DateAdd(a_str_date_part, ii, arguments.date_start), q_return.recordcount)>
</cfloop>