
<cfset q_select_distinct_countries = stReturn.q_select_distinct_countries>

<cfchart format="flash" showlegend="yes" chartheight="400" chartwidth="600">
	<cfchartseries type="pie" query="q_select_distinct_countries" valuecolumn="percent_country" itemcolumn="b_country"></cfchartseries>
</cfchart>