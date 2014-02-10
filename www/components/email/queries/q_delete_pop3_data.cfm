
<cfparam name="DeletePOP3data.emailaddress" type="string" default="">
<cfparam name="DeletePOP3data.userkey" type="string" default="">

<cfif Len(DeletePOP3data.emailaddress) IS 0 OR
	  Len(DeletePOP3data.userkey) IS 0>
	<cfexit method="exittemplate">	  
</cfif>

<cfquery name="q_delete_pop3_data" datasource="#request.a_str_db_users#">
DELETE FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeletePOP3data.emailaddress#">
;
</cfquery>