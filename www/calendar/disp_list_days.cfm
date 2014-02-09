<!--- f&uuml;r die link-generation vorheriger/n&auml;chster Monat --->
<cfset ACurrentDate = request.a_dt_current_date>

<cfset ACurrentDate = DateAdd("d", 0, ACurrentDate)>
<cfset yourdate_prev = DateAdd("d", "-1", AcurrentDate)>
<cfset yourdate_next = DateAdd("d", "1", AcurrentDate)>

<cfset YearSet = Year(ACurrentDate)>
<cfset MonthSet = Month(ACurrentDate)>

<!--- Create the date variables to search the Database by. --->
<cfset MonthStart = CreateDate(YearSet, MonthSet, 1)>
<cfset MonthEnd = CreateDate(YearSet, MonthSet, DaysInMonth(MonthStart))>

<CFSET OffSet = DayOfWeek(MonthStart)>
<CFSET LastSlot = OffSet + DaysInMonth(MonthStart)-1>
<CFSET CalDays = (Ceiling(LastSlot/7))*7>
<CFSET Day = 1>

<cfset Month2 = DateAdd("m", 1, AcurrentDate)>
<cfset AStartDate = CreateDate(Year(AcurrentDate), Month(AcurrentDate), "1")>
<cfset AEndDate = CreateDate(year(AcurrentDate), Month(AcurrentDate), DaysinMonth(AcurrentDate))>

<cfset AStartDate = DateAdd("h", request.stUserSettings.utcDiff, AStartdate)>
<cfset AEndDate = DateAdd("h", request.stUserSettings.utcDiff, AEndDate)>


<table border="0" cellspacing="0" cellpadding="2" width="100%">
<tr>
	<td align="center" colspan="8" class="NavLeftTableHeader">
	<cfoutput>
	<a href="default.cfm?Action=ViewDay&Date=#urlencodedformat(DateFormat(yourdate_prev, "m/dd/yyyy"))#">
	</cfoutput>
	<img src="/images/links.gif" width="9" height="16" alt="" border="0"></a>
	&nbsp;<font style="font-size : 24px;font-weight : bold;letter-spacing : 0px;">

	<cfoutput>#trim(dateformat(request.a_dt_current_date, "dd.mm. "))#</cfoutput></font>
	&nbsp;
	<a href="default.cfm?Action=ViewDay&Date=<cfoutput>#urlencodedformat(DateFormat(yourdate_next, "m/dd/yyyy"))#"><img src="/images/rechts.gif" width="9" height="16" alt="" border="0"></a></cfoutput>

<br>
<font style="letter-spacing : 5px;font-weight:bold;"><cfoutput>#ucase(LSDateFormat(ACurrentDate, "dddd"))#</cfoutput></font>
</td>
</tr>

<script type="text/javascript">
	function GotoMonth(y, num)
		{location.href = "default.cfm?action=ViewMonth&date="+num+"/1/"+y;}
</script>
<TR>
	<td colspan="8" align="center">
	
	<cfset Aprevmonth =  Dateadd("m", "-1", ACurrentDate)>
	<cfset Aprevmonth = CreateDate(year(Aprevmonth), month(Aprevmonth), 1)>
	<cfset ANextmonth =  Dateadd("m", 1, ACurrentDate)>
	<cfset ANextmonth = CreateDate(year(ANextmonth), month(ANextmonth), 1)>
	
	<cfoutput><a href="default.cfm?Action=ViewMonth&Date=#urlencodedformat(dateformat(Aprevmonth, "m/dd/yyyy"))#" style="text-decoration: none;"></cfoutput><img src="/images/previous.gif" alt="vorheriger Monat" width="10" height="9" border="0"></a>
	
	<select onchange="javascript:GotoMonth('<cfoutput>#year(acurrentdate)#</cfoutput>', this.value);" name="months" style="width:100px;font-weight:bold;">
	<cfset aMonthNavDate = CreateDate("1900", 1, 1)>
	<cfloop index="ii" from="1" to="12">
	<cfoutput><option <cfif month(ACurrentDate) is ii>selected</cfif> value="#ii#">#lsdateformat(aMonthNavDate, "mmmm")#</cfoutput>
	<cfset aMonthNavDate = DateAdd("m", "1", aMonthNavDate)>
	</cfloop>
	</select>
	
	<cfoutput><a href="default.cfm?Action=ViewMonth&Date=#urlencodedformat(dateformat(ANextmonth, "m/dd/yyyy"))#"></cfoutput><img src="/images/next.gif" alt="n&auml;chster Monat" width="10" height="9" border="0"></a><br>
	</td>
</tr>
	<TR>
	<cfoutput>
		<td class="bdashedbottom">#GetLangval("cal_wd_short_wee")#</td>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_sun")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_mon")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_tue")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_wed")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_thu")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_fri")#</TD>
		<Td class="bdashedbottom">#GetLangval("cal_wd_short_sat")#</TD>
	</TR>
	</cfoutput>	
	<TR>
	<cfset anavDate = CreateDate(year(AcurrentDate), month(ACurrentDate), 1)>
	<cfset aNavDateStr = urlencodedformat(dateformat(anavDate, "m/dd/yyyy"))>
		<td align="right" class="bdashedright"><cfoutput><a class="calnav" href="default.cfm?action=ViewWeek&Date=#aNavDateStr#">#week(anavDate)#</a></td></cfoutput>
		<CFLOOP INDEX="ii" FROM="1" TO="#CalDays#">
			<CFIF ii GTE Offset and ii LTE LastSlot>
				<TD class="calnav" <cfif Day IS Day(Now()) AND Month(MonthStart) IS Month(Now())>style="border:red solid 1px;"</cfif>>
				
				<!---<cfset AFound = 0>
				<cfloop from="1" index="aiiDay" to="#arraylen(AQueryArray)#">
					<cfif AFound is 0 AND AQueryArray[aiiDay] is Day><cfset AFound = 1><b></cfif>
				</cfloop>--->
								
				<CFOUTPUT><a class="calnav" href="default.cfm?Action=ViewDay&Date=#urlencodedformat(month(ACurrentdate)&"/"&Day&"/"&year(ACurrentDate))#">#Day#</a></cfoutput>
				</TD>
				<CFSET Day = Day + 1>
			<CFELSE>
				<TD>&nbsp;</TD>
			</CFIF>			
			
			<CFIF (ii mod 7 is 0) >
			</TR>
			<TR>
			<cfset ATmpWeekNavDate = CreateDate(year(AcurrentDate), month(ACurrentDate), day-1)>
			<cfset ATmpWeekNavDate = DateAdd("d", 2, ATmpWeekNavDate)>
			
				<CFIF Month(ATmpWeekNavDate) is Month(AcurrentDate)>
				<cfset a_str_dt_link = dateformat(ATmpWeekNavDate, "m/dd/yyyy")>
				<td class="bdashedright" align="right"><a class="calnav" href="default.cfm?action=ViewWeek&Date=<cfoutput>#urlencodedformat(a_str_dt_link)#</cfoutput>"><cfoutput>#week(ATmpWeekNavDate)#</cfoutput></a></td>
				</CFIF>
			</CFIF>
		</CFLOOP>
	

	</TR>
</TABLE>