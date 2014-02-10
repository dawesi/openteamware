

<cfquery name="q_select_photo_settings" datasource="#request.a_str_db_users#">
SELECT
	bigphotoavaliable,smallphotoavaliable,username,entrykey
FROM
	users
WHERE
	<cfif Len(arguments.username) GT 0>
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	</cfif>
	
	<cfif Len(arguments.userkey) GT 0>
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	</cfif>
;
</cfquery>