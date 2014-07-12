<!--- // output a table ... // --->

<cfsavecontent variable="a_str_output">

<table border="0" cellspacing="0" cellpadding="4">
<tr class="mischeader">
	<td class="bb bt bl" style="font-size:10px; ">
		&nbsp;
	</td>
	<td class="bb bt addinfotext" style="font-size:10px; ">
		#
	</td>
<cfloop list="#arguments.query.columnlist#" index="a_str_col_name">
    <td class="bb bt bl" style="font-size:10px;font-weight:bold; ">

		<a class="addinfotext" href="javascript:SortByField('<cfoutput>#jsstringformat(a_str_col_name)#</cfoutput>');">

		<!--- // check if another name exists // --->
		<cfif StructKeyExists(a_struct_db_fieldnames, a_str_col_name)>
			<cfoutput>#a_struct_db_fieldnames[a_str_col_name]#</cfoutput>
		<cfelse>
			<cfoutput>#a_str_col_name#</cfoutput>
		</cfif>

		</a>
	</td>
</cfloop>
</tr>

<tr>
	<td colspan="2" class="bb">&nbsp;</td>
	<cfloop list="#arguments.query.columnlist#" index="a_str_col_name">

		<cfquery name="q_select_distinct" dbtype="query">
		SELECT
			DISTINCT(#a_str_col_name#) AS distinct_value
		FROM
			arguments.query
		;
		</cfquery>

		<td class="bb bl">

			<cfif q_select_distinct.recordcount GT 1 AND q_select_distinct.recordcount LTE 10>
				<select name="frm">
					<option value=""></option>
					<cfoutput query="q_select_distinct">
						<cfif Len(q_select_distinct.distinct_value) GT 0>
						<option value="#htmleditformat(q_select_distinct.distinct_value)#">#htmleditformat(q_select_distinct.distinct_value)#</option>
						</cfif>
					</cfoutput>
				</select>
			<cfelse>
				&nbsp;
			</cfif>

		</td>
	</cfloop>
</tr>

<cfoutput query="arguments.query">
  <tr>
  	<td class="bb bl" align="right">
		<input type="checkbox" name="frmentrykey" value="" class="noborder">
	</td>
	<td class="bb addinfotext" valign="top" align="right">
		<a href="details">#arguments.query.currentrow#</a>
	</td>
  	<cfloop list="#arguments.query.columnlist#" index="a_str_col_name">
    <td class="bb bl" valign="top">
		<cfset a_str_value = arguments.query[a_str_col_name][arguments.query.currentrow]>
		<cfif Len(a_str_value) GT 0>

			<cfif isDate(a_str_value)>
				#dateformat(a_str_value, arguments.usersettings.default_dateformat)#
			<cfelseif (1 IS 0)>

			<cfelse>
				#htmleditformat(a_str_value)#
			</cfif>

		<cfelse>
			&nbsp;
		</cfif>
	</td>
	</cfloop>
  </tr>
</cfoutput>

</table>

</cfsavecontent>

<cfset stReturn.content = a_str_output>