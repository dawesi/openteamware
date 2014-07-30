

<cfquery name="q_select_photodata">
SELECT
	photodata,contenttype
FROM
	userphotos
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectPhotoRequest.userkey#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectPhotoRequest.type#">
;
</cfquery>