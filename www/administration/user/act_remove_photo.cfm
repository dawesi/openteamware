<cfif NOT StructKEyExists(session, 'stSecurityContext')>
	<cfabort>
</cfif>

<!--- userkey --->
<cfparam name="url.entrykey" type="string">

<!--- small (0) or big (1) --->
<cfparam name="url.type" type="numeric">

<cfquery name="q_delete_old_photo" datasource="#request.a_str_db_users#">
DELETE FROM
	userphotos
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">)
	AND
	(type = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.type#">)
;
</cfquery>

<cfquery name="q_update_photo" datasource="#request.a_Str_Db_users#">
UPDATE
	users
SET
	<cfif url.type IS 0>
	smallphotoavaliable = 0
	<cfelse>
	bigphotoavaliable = 0
	</cfif>
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">)
;
</cfquery>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">