<!--- //

	Component:	Security
	Function:	LoadSwitchUsersData
	Description:Load 1:n relations from database
	

// --->

<cfquery name="q_select_switch_user_relations">
SELECT
	dt_created,
	createdbyuserkey,
	userkey,
	otheruserkey,
	otherpassword_md5,
	comment,
	entrykey
FROM
	switchuserrelations
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
	OR
	(otheruserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">)
;
</cfquery>

