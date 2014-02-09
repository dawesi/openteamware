<!--- select current stylesheet --->

<cfquery name="q_select_current_stylesheet" datasource="inboxccusers">
SELECT stylesheet FROM users
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>