
<cfoutput>#CreateDefaultTopHeader(GetLangVal('cm_wd_calendar'))#</cfoutput>

<!---
<cfexit method="exittemplate">

<cfset A_str_link_date = urlencodedformat(dateformat(request.a_dt_current_date, "m/dd/yyyy"))>

<table class="tablemaincontenttop">

<tr>

	
	<cfif IsInternalIPOrUser()>
		<td class="addinfotext" style="font-weight:bold; ">
			<a class="addinfotext" href="/calendar/"><cfoutput>#GetLangVal('cm_wd_calendar')#</cfoutput></a>
		</td>
	<cfelse>

	<td><a href="default.cfm" class="TopHeaderLink"><b><cfoutput>#GetLangVal('cal_wd_today')#</cfoutput></a></b></td>

	
	<td class="tdtopheaderdivider">|</td>
	<td class="TopHeaderLink">
	<cfoutput>#GetLangVal('cm_wd_view')#</cfoutput>:
	&nbsp;<a href="default.cfm?action=ViewDay&Date=<cfoutput>#A_str_link_date#</cfoutput>" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_wd_day')#</cfoutput></a>
	&nbsp;<a href="default.cfm?action=ViewWeek&Date=<cfoutput>#A_str_link_date#</cfoutput>" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_wd_week')#</cfoutput></a>
	&nbsp;<a href="default.cfm?action=ViewMonth&Date=<cfoutput>#A_str_link_date#</cfoutput>" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_wd_month')#</cfoutput></a>
	&nbsp;<a href="default.cfm?action=ViewYear&Date=<cfoutput>#A_str_link_date#</cfoutput>" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_wd_year')#</cfoutput></a>
	&nbsp;<a href="default.cfm?action=ListEvents&Date=<cfoutput>#A_str_link_date#</cfoutput>" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_wd_list')#</cfoutput></a>
	</td>

	<td class="tdtopheaderdivider">|</td>

	<td><a href="default.cfm?action=newevent" class="TopHeaderLink"><cfoutput>#GetLangVal('cal_ph_top_createevent')#</cfoutput></a></td>
	
	<td class="tdtopheaderdivider">|</td>
	
	<cfif ListFindNoCase('ViewDay,ShowDay,ViewWeek,ViewMonth,ShowEvent,ListEvents', url.action) GT 0>
		<td>
			<a class="TopHeaderLink" target="_blank" href="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&printmode=true"><cfoutput>#GetLangVal('cal_ph_top_printversion')#</cfoutput></a>
		</td>
		<td class="tdtopheaderdivider">|</td>
	</cfif>

	<td><a href="/synccenter/" class="TopHeaderLink"><cfoutput>#GetLangVal('cm_ph_synccenter_link')#</cfoutput></a></td>

	
	</cfif>
</tr>
</table> 
--->