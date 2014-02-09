<!--- //

	select the autologin key for a certain userid
	
	<io>
		<in>
		<param name="key" scope="SelectAutologinkeyRequest" type="string" default="">
		<description>
		the autologin key ... created by uuid
		</description>
		</param>
		</in>
		
		<out>
		<param name="a_return_str_username" scope="" type="string" default="">
			<description>
			username
			</description>
		</param>
		<param name="a_return_str_password" scope="" type="string" default="">
			<description>
			the password
			</description>
		</param>
		<param name="a_return_bol_found" scope="" type="boolean" default="false">
			<description>
			hit or not?
			</description>
		</param>		
		</out>
	</io>
	
	// --->
	
<cfquery name="q_select_autologinkey" datasource="#request.a_str_db_users#">
SELECT username,pwd FROM users
WHERE autologin_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectAutologinkeyRequest.key#">;
</cfquery>

<cfset a_return_str_username = q_select_autologinkey.username>
<cfset a_return_str_password = q_select_autologinkey.pwd>

<cfset a_return_bol_found = q_select_autologinkey.recordcount is 1>