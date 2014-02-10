
<cfquery name="q_select_re_data_available_for_user" datasource="#GetDSName()#">
SELECT
	redata.entrykey
FROM
	redata
LEFT JOIN addressbook ON
	(addressbook.entrykey = redata.entrykey)
WHERE
	addressbook.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>