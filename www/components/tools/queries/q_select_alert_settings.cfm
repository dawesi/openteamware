<cfquery name="q_select_alert_settings">
SELECT
	userkey,servicekey,events,notifyemail,notifysms,notifyreminder
FROM
	alertsettings
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
<cfif StructKeyExists(arguments.filter, 'servicekey')>
	AND
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.servicekey#">
</cfif>
<cfif StructKeyExists(arguments.filter, 'objectkey')>
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.objectkey#">
</cfif>
ORDER BY
	servicekey,objectkey
;
</cfquery>