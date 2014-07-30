<!--- //

	select the user data
	
	// --->
	
<cfparam name="SelectUserdataRequest.entrykey" type="string" default="">

<cfquery name="q_select_user_data">
SELECT * FROM users
<!---WHERE <cfinclude template="inc_qry_resellerkey.cfm"> AND --->
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectUserdataRequest.entrykey#">;
</cfquery>