<cfparam name="UpdateOpenRecordsRequest.companykey" type="string" default="">

<cfquery name="q_update_open_records" datasource="#request.a_str_db_users#">
UPDATE
	bookedservices
SET
	settled = 1
WHERE
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectOpenRecordsRequest.companykey#">)
	AND
	settled = 0
;
</cfquery>