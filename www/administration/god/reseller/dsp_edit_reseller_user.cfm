
<cfquery name="q_select_item">
SELECT
	*
FROM
	resellerusers
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#">
;
</cfquery>


<cfset CreateEditResellerUser.action = 'edit'>
<cfset CreateEditResellerUser.query = q_select_item>

<cfinclude template="dsp_inc_create_edit_reseller_user.cfm">