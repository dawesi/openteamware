<!--- //

	Module:		Calendar
	Description:View the whole year
	

// --->


<cfset tmp = SetHeaderTopInfoString(Year(ACurrentDate)) />

<cftry>

<table cellpadding="4" cellspacing="4" border="0">

<tr>

<cfloop from="1" to="12" index="a_int_month_number">

	<td valign="top">

	

	<cfset a_int_loopstart = Dayofweek(CreateDate(year(ACurrentDate), a_int_month_number, 1)) - 2>

	<cfif a_int_loopstart lt 0><cfset a_int_loopstart = 6></cfif>

	

	<cfset a_dt_date2display = CreateDate(year(ACurrentDate), a_int_month_number, 1)>

	<CFSET a_int_datecount = 1>

		

	<a style="font-weight:bold; " href="index.cfm?action=ViewMonth&Date=<cfoutput>#DateFormat(CreateDate(year(ACurrentDate), a_int_month_number, 1), "mm/dd/yyyy")#</cfoutput>"><img src="/images/si/calendar.png" class="si_img" /> <cfoutput>#LsDateFormat(CreateDate(1900, a_int_month_number, 1), "mmmm")#</cfoutput> (<cfoutput>#a_int_month_number#</cfoutput>)</a>

	



	<TABLE cellpadding="4" cellspacing="0" border="0" class="b_all">

	<TR class="mischeader">

	<cfoutput>

		<td>#GetLangval("cal_wd_short_mon")#</td>

		<td>#GetLangval("cal_wd_short_tue")#</td>

		<td>#GetLangval("cal_wd_short_wed")#</td>

		<td>#GetLangval("cal_wd_short_thu")#</td>

		<td>#GetLangval("cal_wd_short_fri")#</td>

		<td>#GetLangval("cal_wd_short_sat")#</td>

		<td>#GetLangval("cal_wd_short_sun")#</td>

	</cfoutput>

	</TR>

	<CFIF a_int_loopstart NEQ 0>

		<CFLOOP FROM="1" TO="#a_int_loopstart#" INDEX="firstweek">

			<TD>&nbsp;</TD>

		 </CFLOOP>

	</CFIF>

	

	<CFSET a_int_week1 = 7 - a_int_loopstart>

	  <CFLOOP FROM="1" TO="#a_int_week1#" INDEX="Loop2">

	  	<TD align="right">

		<CFOUTPUT>

		<a class="calnav" href="index.cfm?action=ViewDay&Date=#urlencodedformat(dateformat(createdate(Year(ACurrentDate), a_int_month_number, a_int_datecount), "mm/dd/yyyy"))#">#a_int_datecount#</a>

		</CFOUTPUT>

		<CFSET a_int_datecount = a_int_datecount + 1>

		</TD>

	 	</CFLOOP>



		</TR>

		<CFSET WeekIndex = 0>

	  	<CFSET LOOPTO = DaysInMonth(a_dt_date2display) - 1>

	  	<CFLOOP FROM="#a_int_week1#" TO="#loopto#" INDEX="Loop3">

	  	<CFIF WeekIndex EQ 0><TR></CFIF>

		<TD align="right">

		<CFOUTPUT>

		<a class="calnav" href="index.cfm?action=ViewDay&Date=#urlencodedformat(dateformat(createdate(Year(ACurrentDate), a_int_month_number, a_int_datecount), "mm/dd/yyyy"))#">#a_int_datecount#</a>

		</CFOUTPUT>

		</TD>

		<CFSET WeekIndex = WeekIndex + 1><CFSET a_int_datecount = a_int_datecount + 1>

	  	<CFIF WeekIndex EQ 7></TR><CFSET WeekIndex = 0></CFIF>

	  	</CFLOOP>



		<CFIF WeekIndex NEQ 0>

	  	<CFLOOP FROM="#WeekIndex#" TO="6" INDEX="Loop4">

		<TD>&nbsp;</TD>

		</CFLOOP>

		</CFIF>

		</TR>

	</TABLE>

	



	</td>

	

	<!--- wrap --->

	<cfif a_int_month_number mod 4 is 0>

		</tr><tr>

	</tr></cfif>

</cfloop>



</table>

<cfcatch type="any"><cfoutput>#cfcatch.Message#</cfoutput></cfcatch></cftry>


