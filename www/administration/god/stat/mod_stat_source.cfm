<cfscript>
/**
 * Generates a structure of days for the week, including the beginning and end of the week.
 * Rewrite by Raymond Camden
 * 
 * @param date 	 Date to use. Defaults to this week. 
 * @return Returns a structure. 
 * @author Rich Rein (richard.rein@medtronic.com) 
 * @version 2, February 25, 2002 
 */
function thisWeek() {
	var dayOrdinal = 0;
	var returnStruct = structNew();
	var current_date = now();
	
	if (arrayLen(arguments)) current_date = arguments[1];
	dayOrdinal = DayOfWeek(current_date);
	
	returnStruct.weekBegin = dateAdd("d",-1 * (dayOrdinal-1), current_date);
	returnStruct.weekEnd = dateAdd("d",7-dayOrdinal, current_date);
	returnStruct.weekNo = Week(returnStruct.weekBegin);
	
	for(i=1; i LTE 7; i=i+1) {
		StructInsert(returnStruct,DayOfWeekAsString(i),dateAdd("d",i-1,returnStruct.weekBegin));
	}
	
	return returnStruct;

}
</cfscript>


<cfparam name="attributes.includetrialcustomers" type="boolean" default="true">

<cfquery name="q_select_companies">
SELECT
	entrykey,companyname,resellerkey,id,status,signupsource,createdbyuserkey,
	countryisocode,zipcode,DATE_FORMAT(dt_created, '%Y%m%d') AS date_created,
	dt_created AS dt_created_original,0 AS weekno
FROM
	companies
<cfif attributes.includetrialcustomers IS FALSE>
WHERE
	status = 0
</cfif>
;
</cfquery>

<cfif attributes.includetrialcustomers>
	<cfquery name="q_select_old_companies">
	SELECT
		signupsource,DATE_FORMAT(dt_created, '%Y%m%d') AS date_created,dt_created AS dt_created_original,0 AS weekno
	FROM
		oldcompanies
	;
	</cfquery>
	
	<cfloop query="q_select_old_companies">
		<cfset QueryAddRow(q_select_companies, 1)>
		
		<cfloop list="#q_select_old_companies.columnlist#" index="a_str_column" delimiters=",">
			<cfset QuerySetCell(q_select_companies, a_str_column, q_select_old_companies[a_str_column][q_select_old_companies.currentrow], q_select_companies.recordcount)>
		</cfloop>
	</cfloop>

</cfif>

<cfquery name="q_select_sources" dbtype="query">
SELECT
	DISTINCT(LOWER(signupsource))
FROM
	q_select_companies
;
</cfquery>

<cfloop query="q_select_companies">
	<cfset QuerySetCell(q_select_companies, 'weekno', Week(q_select_companies.dt_created_original), q_select_companies.currentrow)>
</cfloop>

<cfset q_signup = QueryNew('source,count_total,date_selected,weekno')>

<cfloop from="0" to="30" index="ii">

	<cfset a_dt_week = DateAdd('w', -#ii#, Now())>
	
	<cfset a_struct_week = thisWeek(a_dt_week)>
	
	<cfset a_dt_week_begin = DateFormat(a_struct_week.WEEKBEGIN, 'yyyymmdd')>
	<cfset a_dt_week_end = DateFormat(a_struct_week.WEEKEND, 'yyyymmdd')>
	
	
	<cfoutput query="q_select_sources">
		<cfquery name="q_select_sum" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_companies
		WHERE
			LOWER(signupsource) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_sources.signupsource#">
			AND
			weekno = <cfqueryparam cfsqltype="cf_sql_integer" value="#Week(a_dt_week)#">
		;
		</cfquery>
		
		<cfset QueryAddRow(q_signup, 1)>
		<cfset QuerySetCell(q_signup, 'source', q_select_sources.signupsource, q_signup.recordcount)>
		<cfset QuerySetCell(q_signup, 'count_total', q_select_sum.count_id, q_signup.recordcount)>	
		<cfset QuerySetCell(q_signup, 'weekno', Week(a_Dt_week), q_signup.recordcount)>
		
		<!---<cfdump var="#q_select_sum#">--->
	</cfoutput>
</cfloop>

<cfdump var="#q_signup#">



<cfsavecontent variable="graph_data">
<cfchart showlegend="yes" showmarkers="no" chartwidth="600" format="png">
	<cfchartseries query="q_signup" seriescolor="##FF9933" itemcolumn="source" valuecolumn="count_total" type="curve"  serieslabel="Quellen">
</cfchart>

</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>