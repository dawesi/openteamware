<!--- show codes --->

<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	reseller_promocode_mappings 
;
</cfquery>

<table border="0" cellspacing="0" cellpadding="10">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<cfoutput query="q_select">
  <tr>
    <td>
		<cfquery name="q_Select_name" dbtype="query">
		SELECT
			companyname
		FROM
			request.q_Select_reseller
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.resellerkey#">
		;
		</cfquery>
		
		#q_Select_name.companyname#
	</td>
    <td>
		#q_select.startcode# - #q_select.endcode#
	</td>
    <td>
		#q_select.dt_created#
	</td>
    <td>&nbsp;</td>
  </tr>
</cfoutput>
</table>