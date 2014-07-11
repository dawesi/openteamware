<cfparam name="url.parentid" type="numeric" default="0">


<form action="criteria/act_add_criteria.cfm" method="post">
	<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
	<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
	<input type="hidden" name="frmparentid" value="<cfoutput>#url.parentid#</cfoutput>">
	
	<table class="table table_details table_edit_form">
	  <tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmname" size="25" value="" maxlength="100">
		</td>
	  </tr>
	  <tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmdescription" value="" size="25" maxlength="250">
		</td>
	  </tr>
	  
	  <cfif url.parentid GT 0>
	  <tr>
	  	<td class="field_name">
			<cfoutput>#GetLangVal('cm_ph_superior_element')#</cfoutput>:
		</td>
		<td>
			<cfquery name="q_select_parent_criteria" dbtype="query">
			SELECT
				*
			FROM
				q_select_all_criteria
			WHERE
				id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.parentid#">
			;
			</cfquery>
			
			<cfoutput>#q_select_parent_criteria.criterianame#</cfoutput>
		</td>
	  </tr>
	  </cfif>
	  <tr>
		<td class="field_name">&nbsp;</td>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" class="btn btn-primary" />
		</td>
	  </tr>
	</table>
</form>