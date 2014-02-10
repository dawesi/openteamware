
<cfquery name="q_select_securityroles_ip_restrictions" datasource="#request.a_str_db_users#">
SELECT
	restrictiontype,restrictionvalue,active,createdbyuserkey,dt_created,direction,rolekey
FROM
	restrictlogins
WHERE
	rolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>