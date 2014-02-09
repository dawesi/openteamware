
<cfparam name="SelectEmailAttributes.messageid" type="string" default="">

<cfquery name="q_select_email_attributes" datasource="#request.a_str_db_tools#">
SELECT
	categories,rating
FROM
	emailattributes
WHERE
	messageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectEmailAttributes.messageid#">
;
</cfquery>