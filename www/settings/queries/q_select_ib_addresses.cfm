<!--- select all openTeamWare email addresses



	scope: session

	

	

	--->
	
<cfquery name="q_select_ib_addresses" datasource="#request.a_str_db_users#">
SELECT
	* 
FROM
	pop3_data
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)
	AND
	(origin = 0)
; 
</cfquery>
