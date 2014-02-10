<cfif Len(a_str_messageids) IS 0>
	<cfset a_str_messageids = 'ABC' />
</cfif>

<cfexit method="exittemplate">



<!--- select message-ids of references table ... --->
<cfquery name="q_select_ref_m" datasource="#request.a_str_db_tools#">
SELECT
	messageid
FROM
	email_references
WHERE
	<!--- the message - id --->
	reference_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.messageid#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>

<cfif q_select_ref_m.recordcount GT 0>
	<cfset a_str_messageids = a_str_messageids & ',' & ValueList(q_select_ref_m.messageid)>
</cfif>

<cfif Len(a_str_messageids) IS 0>
	<cfset a_str_messageids = 'ABC' />
</cfif>

<cfquery name="q_select_reference_messages" datasource="#request.a_str_db_tools#">
SELECT
	id,uid,dt_created,foldername,datatype,source,messageid
FROM
	emailmetadata_information
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
	AND
	(messageid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_messageids#" list="yes">))
ORDER BY
	dt_created DESC
;
</cfquery>

<!--- select reference messages and than do re-select ... --->
<cfif q_select_reference_messages.recordcount GT 0>
	<cfquery name="q_select_ref_m" datasource="#request.a_str_db_tools#">
	SELECT
		messageid
	FROM
		email_references
	WHERE
		<!--- the message - id --->
		reference_id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_reference_messages.messageid)#" list="yes">)
		AND
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	;
	</cfquery>
	
	<cfif q_select_ref_m.recordcount GT 0>
		<cfset a_str_messageids = a_str_messageids & ',' & valuelist(q_select_ref_m.messageid)>
	</cfif>
</cfif>

<cfquery name="q_select_reference_messages" datasource="#request.a_str_db_tools#">
SELECT
	id,uid,dt_created,foldername,datatype,source,messageid
FROM
	emailmetadata_information
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
	AND
	(messageid IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_messageids#" list="yes">))
ORDER BY
	dt_created DESC
;
</cfquery>

<cfquery name="q_select_reference_messages" dbtype="query">
SELECT
	uid,dt_created,foldername,messageid,id
FROM
	q_select_reference_messages
WHERE
	NOT
	uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.originaluid#">
;
</cfquery>