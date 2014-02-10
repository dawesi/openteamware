<cfquery name="q_select_check_simple_login" datasource="#request.a_str_db_users#">
SELECT
	COUNT(userid) AS count_id
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	
	<cfif Len(arguments.password_md5) GT 0>
		MD5(pwd) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.password_md5)#">
	<cfelse>
		pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
	</cfif>
	
	AND
	allow_login = 1
;
</cfquery>