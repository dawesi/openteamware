
<cfparam name="LoadImportantUserdata.username" type="string" default="">
<cfparam name="LoadImportantUserdata.entrykey" type="string" default="">

<cfif Len(LoadImportantUserdata.username) IS 0 AND Len(LoadImportantUserdata.entrykey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_important_userdata">
SELECT
	utcdiff,username,entrykey,firstname,surname,sex,companykey
FROM
	users
WHERE
	<cfif Len(LoadImportantUserdata.username) GT 0>
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadImportantUserdata.username#">
	</cfif>
	
	<cfif Len(LoadImportantUserdata.entrykey) GT 0>
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadImportantUserdata.entrykey#">
	</cfif>
;
</cfquery>