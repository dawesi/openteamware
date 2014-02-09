<!--- //

	

	select properties of an email address

	

	scope: session, selectemailrequest

	

	// --->

<cfparam name="selectemailrequest.id" default="0" type="numeric">	



<cfquery name="q_select_emailadr" datasource="#request.a_str_db_users#">
SELECT
	id,Displayname,emailadr,pop3username,pop3server,pop3password,deletemsgonserver,autocheckeachhours,AutoCheckMinutes
FROM
	pop3_data
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)
	AND
	(id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(selectemailrequest.id)#">)
;
</cfquery>