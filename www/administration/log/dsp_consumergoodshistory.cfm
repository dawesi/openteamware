<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="#request.a_str_component_logs#" method="GetCommissiongoodsHistory" returnvariable="q_select_log">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<br>
<cfoutput>#GetLangVal('adm_ph_items_found')#</cfoutput>: <cfoutput>#q_select_log.recordcount#</cfoutput>

<cfif q_select_log.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>
<br><br>

<cfquery name="q_select_log" dbtype="query">
SELECT
	*,'' AS username
FROM
	q_select_log
;
</cfquery>

<cfquery name="q_select_distinct_users" dbtype="query">
SELECT
	DISTINCT(userkey)
FROM
	q_select_log
;
</cfquery>

<cfquery name="q_select_usernames" datasource="#request.a_Str_db_users#">
SELECT
	username,entrykey
FROM
	users
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_distinct_users.userkey)#" list="yes">)
;
</cfquery>


<table border="0" cellspacing="0" cellpadding="4" bordercolor="silver" style="border-collapse:collapse; ">
  <tr class="mischeader">
    <td><cfoutput>#GetLangVal('cm_ph_date_time')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput></td>
	<td><cfoutput>#GetLangVal('cm_wd_points')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_log">
  <tr>
  	<td>
		#DateFormat(q_select_log.dt_created, 'dd.mm.yy')#
	</td>
	<td>
		<cfquery name="q_select_username" dbtype="query">
		SELECT
			username
		FROM
			q_select_usernames
		WHERE
			entrykey = '#q_select_log.userkey#'
		;
		</cfquery>
		
		#q_select_username.username#
		
	</td>
	<td align="right">
		#q_select_log.points#
	</td>
	</tr>
  </cfoutput>
</table>