
<cfparam name="form.FRM_CRITERIA_ID" type="string" default="">

<cfset a_str_ids = ''>

<cfset q_select_criteria = application.components.cmp_crmsales.GetFullCriteriaQuery(companykey = request.stSecurityContext.mycompanykey)>

<cfloop list="#form.FRM_CRITERIA_ID#" delimiters="," index="a_str_id">

	<cfset a_str_id = val(a_str_id)>
	
	<!--- build full range back to parent ... --->
	
	<cfset a_str_range = GetAllCriteriaParentElements(id = a_str_id, query_all = q_select_criteria)>
	
	<!--- ok, we have now the full range --->
	<cfset a_str_ids = ListAppend(a_str_ids, a_str_range)>
	
</cfloop>

<cfdump var="#a_str_ids#">

<html>
	<head>
		<script type="text/javascript">
			function SetSelectCriteriaDone()
				{
				opener.document.<cfoutput>#form.form_name#</cfoutput>.frmcriteria.value = '<cfoutput>#a_str_ids#</cfoutput>';
				opener.UpdateCriteriaDisplay();
				window.close();
				}
		</script>
	</head>
<body onLoad="SetSelectCriteriaDone();">
	1
</body>
</html>



<cffunction access="private" name="GetAllCriteriaParentElements" output="false" returntype="string">
	<cfargument name="id" type="numeric" required="yes">
	<cfargument name="string_already" type="string" required="no" default="" hint="">
	<cfargument name="query_all" type="query" required="yes">
	
	<cfset var sReturn = ''>
	
	<cfset sReturn = ListAppend(arguments.string_already, arguments.id)>
	
	<cfquery name="q_select_has_parent" dbtype="query">
	SELECT
		parent_id
	FROM
		arguments.query_all
	WHERE
		id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
	;
	</cfquery> 
	
	<cfif (val(q_select_has_parent.parent_id) GT 0) AND (ListFindNoCase(sReturn, q_select_has_parent.parent_id) IS 0)>
		<cfset sReturn = trim(GetAllCriteriaParentElements(id = q_select_has_parent.parent_id, string_already = sReturn, query_all = arguments.query_all))>
	</cfif>
	
	<cfreturn sReturn>
</cffunction>