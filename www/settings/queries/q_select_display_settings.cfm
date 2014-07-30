<!--- //



	select display settings



	scope: request

		

	// --->

	

<cfquery name="q_select_display_settings">
SELECT
	confirmlogout,daylightsavinghours,utcdiff,charset,mailcharset
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>