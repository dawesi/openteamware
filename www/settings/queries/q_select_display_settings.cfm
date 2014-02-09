<!--- //



	select display settings



	scope: request

		

	// --->

	

<cfquery name="q_select_display_settings" datasource="#request.a_str_db_users#">
SELECT
	confirmlogout,daylightsavinghours,utcdiff,charset,mailcharset
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>