<!--- //

	select the autologin key
	
	<io>
	<in>
	<param name="myuserid" scope="request" type="integer" default="0">
	<description>
	the userid	
	</description>
	</param>
	</in>
	
	// --->
	
<cfquery name="q_select_autologinkey" datasource="#request.a_str_db_users#">
SELECT autologin_key FROM users
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>