
<cfquery name="q_select_security_roles">
SELECT
	rolename,entrykey,companykey,dt_created,createdbyuserkey,description,
	allow_pda_login,allow_wap_login,allow_outlooksync,allow_www_ssl_only,
	allow_ftp_access,protocol_depth,allow_mailaccessdata_access
FROM
	securityroles
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>