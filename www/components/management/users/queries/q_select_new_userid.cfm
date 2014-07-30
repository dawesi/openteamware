<!--- //

	select the new userid ...
	
	// --->
	
<cfparam name="SelectNewUseridRequest.entrykey" type="string" default="">
	
<!--- get the new userid --->
<cfquery name="q_select_new_userid">
SELECT
	userid
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectNewUseridRequest.entrykey#">
;
</cfquery>