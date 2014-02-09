<!--- //

	update autologin 
	
	<io>
	<in>
	<param name="userid" scope="SetAutologinKeyRequest" type="integer" default="0">
		<description>
		the userid	
		</description>
	</param>
	<param name="Autologinkey" scope="SetAutologinKeyRequest" type="string" default="">
		<description>
		the new autologin key	
		</description>
	</param>
	</in>
	
	// --->
<cfparam name="SetAutologinKeyRequest.Autologinkey" type="string" default="">
<cfparam name="SetAutologinKeyRequest.userid" type="numeric" default="0">
	
<cfquery name="q_update_autologinkey" datasource="#request.a_str_db_users#">
UPDATE users
SET autologin_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SetAutologinKeyRequest.autologinkey#">
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#SetAutologinKeyRequest.userid#">;
</cfquery>