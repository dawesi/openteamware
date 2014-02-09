<!--- //

	test
	
	// --->
<cfparam name="url.interval" type="string" default="day">
<cfparam name="url.resellerkey" type="string" default="">
<cfparam name="url.includesubresellers" type="numeric" default="0">

<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	reseller
WHERE
	contractingparty = 1
;
</cfquery>

<cfset request.q_select_reseller = q_select_reseller>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.resellerkeys = ''>

<!--- overall ... --->
<form action="default.cfm" method="get">
	<input type="hidden" name="action" value="test">
	Reseller:
	<select name="resellerkey">
		<option value="">Alle</option>
		<cfquery name="q_select_top" dbtype="query">
		SELECT
			*
		FROM
			q_select_reseller
		WHERE
			parentkey = ''
		;
		</cfquery>
		<cfoutput query="q_select_top">
			<option value="#q_select_top.entrykey#">#q_select_top.companyname#</option>
			<cfmodule template="dsp_inc_reseller_option_items.cfm" entrykey=#q_select_top.entrykey#>
		</cfoutput>
	</select>
		
	
	<br>
	<input type="checkbox" name="includesubresellers" class="noborder" value="1" <cfoutput>#WriteCheckedElement(url.includesubresellers, 1)#</cfoutput>> inkl. Unter-Reseller
	<br><br>
	<br>
	<input type="radio" name="interval" <cfoutput>#WriteCheckedElement(url.interval, 'day')#</cfoutput> value="day" class="noborder"> Tag
	&nbsp;&nbsp;
	<input type="radio" name="interval" value="week" class="noborder"> Woche
	&nbsp;&nbsp;
	<input type="radio" name="interval" value="month" class="noborder"> Monat
	&nbsp;&nbsp;
	<br>
	Trial/Customer
	<br><br>
	
	<input type="submit" value="Anzeigen">
</form>

<cfinvoke component="#request.a_str_component_admin_stat#" method="Customers_GenerateReturnQuery" returnvariable="stReturn">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="interval" value="#url.interval#">
</cfinvoke>
<cfset q_select_customers = stReturn.q_return>

<h4>Anmeldungen</h4>
<cfchart chartwidth="700" format="png" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" fontitalic="no" show3d="no" rotated="no" sortxaxis="no" showlegend="yes" showmarkers="no">
	<cfchartseries seriescolor="##CCCCCC" serieslabel="Anmeldungen" type="bar" query="q_select_customers" valuecolumn="data1" itemcolumn="date_data_display"></cfchartseries>
	<cfchartseries serieslabel="Aktiviert" type="bar" query="q_select_customers" valuecolumn="data4" itemcolumn="date_data_display"></cfchartseries>
	<cfchartseries serieslabel="Zahlend" type="bar" query="q_select_customers" valuecolumn="data2" itemcolumn="date_data_display"></cfchartseries>
</cfchart>
<br><br>
<i>Rohdaten</i>
<table border="1" bordercolor="silver" cellspacing="0" cellpadding="4" style="border-collapse:collapse; ">
	<tr>
		<td>&nbsp;</td>
		<td>
			Angelegt
		</td>
		<td colspan="2">
			Aktiviert
		</td>
		<td colspan="2">
			Zahlend
		</td>
		<td>&nbsp;
			
		</td>
	</tr>
	<cfoutput query="q_Select_customers">
		<tr>
			<td>
				#q_Select_customers.date_data_display#
			</td>
			<td align="right">
				#q_Select_customers.data1#
			</td>
			<td align="right">
				#q_Select_customers.data4#
			</td>
			<td align="right">
				<cfif DateDiff('d', q_Select_customers.date_start, Now()) LT 30><font class="addinfotext"></cfif>
				
				<cfset a_int_one_perc = val(q_select_customers.data1) / 100>
				<cftry>
				#DecimalFormat((q_Select_customers.data4/a_int_one_perc))#%
				<cfcatch type="any">&nbsp;</cfcatch></cftry>
			</td>
			<td align="right">
				#q_Select_customers.data2#
			</td>			
			<td align="right">
			<cfif DateDiff('d', q_Select_customers.date_start, Now()) LT 30><font class="addinfotext"></cfif>
				
				<cfset a_int_one_perc = val(q_select_customers.data4) / 100>
				<cftry>
				#DecimalFormat((q_Select_customers.data2/a_int_one_perc))#%
				<cfcatch type="any">&nbsp;</cfcatch></cftry>
			</td>
			<td>&nbsp;
				
			</td>
		</tr>
	</cfoutput>
</table>

<br><br><br>
<cfinvoke component="#request.a_str_component_admin_stat#" method="Customers_GenerateReturnQuery" returnvariable="stReturn">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="interval" value="#url.interval#">
	<cfinvokeargument name="stat_type" value="logins">
</cfinvoke>
<cfset q_select_logins = stReturn.q_return>
<h4>Logins</h4>
<cfchart chartwidth="770" format="png" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" fontitalic="no" show3d="no" rotated="no" sortxaxis="no" showlegend="no" showmarkers="no">
	<cfchartseries type="line" valuecolumn="data1" query="q_select_logins" itemcolumn="date_data_display"></cfchartseries>
</cfchart>
<cfabort>
<br><br><br>
<cfinvoke component="#request.a_str_component_admin_stat#" method="Customers_GenerateReturnQuery" returnvariable="stReturn">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="interval" value="#url.interval#">
	<cfinvokeargument name="stat_type" value="http_referer">
</cfinvoke>
<cfset q_select_customers = stReturn.q_return>
<cfdump var="#stReturn#">
