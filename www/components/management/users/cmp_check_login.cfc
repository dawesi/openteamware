<!--- //

	Module:		Simple login checks
	Action:		
	Description:	
	

// --->
<cfcomponent>
	<cfinclude template="/common/app/app_global.cfm">

	
	<!--- check if username/password is valid ... --->
	<cffunction access="public" name="CheckLogin" output="false" returntype="struct">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		<cfargument name="remoteaddress" type="string" required="true" default="#cgi.remote_Addr#">
		<cfargument name="defaultdomain" type="string" required="false" default="">
		
		<cfset var a_bol_check_restrictions_result = false />
		<cfset var q_check_data = 0 />
		<cfset var a_cmp_check_restriction = 0 />
		<cfset var stReturn = StructNew() />
		
		<!--- if no domain has been provided ... set one --->
		<cfif FindNoCase("@", arguments.username) is 0 AND Len(arguments.defaultdomain) gt 0>
			<cfset arguments.username = arguments.username&"@"&arguments.defaultdomain>
		</cfif>
		
		<cfquery name="q_check_data" datasource="#request.a_str_db_users#">
		SELECT
			userid,entrykey
		FROM
			users
		WHERE
			(UPPER(username) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#(arguments.username)#">)
		AND
			(UPPER(pwd) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.password)#">)
		;
		</cfquery>
		
		<!--- check now for possible restrictions!! --->
		<cfset a_bol_check_restrictions_result = false>
		
		<cfif q_check_data.recordcount is 1>
			<!--- check login restrictions ... --->
			<cfset a_cmp_check_restriction = CreateObject("component", "cmp_check_login")>
			<cfset a_bol_check_restrictions_result = a_cmp_check_restriction.CheckLoginRestrictions(q_check_data.userid, arguments.remoteaddress)>
		</cfif>
		
		
		<cfset stReturn["userid"] = val(q_check_data.userid)>
		<cfset stReturn["entrykey"] = q_check_data.entrykey>
		<!--- true ... user must be OK and restrictions --->
		<cfset stReturn["ok"] = (q_check_data.recordcount gt 0) AND (a_bol_check_restrictions_result is true)>
		
		<cfreturn stReturn>	
	</cffunction>
	
	<cffunction name="CheckLoginRestrictions" access="public" output="false" returntype="boolean">
		<cfargument name="userid" type="numeric" required="true" default="0">
		<cfargument name="userkey" type="string" required="true" default="">
		<cfargument name="remoteaddress" type="string" required="true" default="#cgi.REMOTE_ADDR#">
		
		<cfset var a_bol_allowed = true />
		
		<!--- <cfquery name="q_select_restrictions" datasource="#request.a_str_db_users#">
		SELECT
			restrictiontype,restrictionvalue,direction
		FROM
			restrictlogins
		WHERE
			userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
			AND
			active = 1
		;
		</cfquery>
		
		<!--- default: login is not allowed --->
		<cfset a_bol_allowed = false>
		
		<!--- do we've any restrictions? --->
		<cfif q_select_restrictions.recordcount gt 0>
				
				<!--- check ip restrictions ... --->
				<cfquery name="q_select_ip_restrictions" dbtype="query">
				SELECT * FROM  q_select_restrictions
				WHERE restrictiontype = 2;
				</cfquery>
				
				<cfloop query="q_select_ip_restrictions">
					<cfif FindNoCase(",", q_select_ip_restrictions.restrictionvalue) gt 0>
					
						<!--- several ip addresses --->				
						<cfloop index="a_str_ip" list="#q_select_ip_restrictions.restrictionvalue#" delimiters=",">
							<cfset a_tmp_bol = CompareIPAddresses(a_str_ip,arguments.remoteaddress)> 
							
							<cfif a_tmp_bol is true>
								<!--- ok! --->
								<cfset a_bol_allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						
					<cfelse>
						<!--- fix IP or a mask			
						f.e. 127.0.0.1 or 172.16.100.xxx --->
						<cfset a_bol_allowed = CompareIPAddresses(q_select_ip_restrictions.restrictionvalue,arguments.remoteaddress)>
					</cfif>
				</cfloop>
				
				<!--- now, check the time ... 
				
					only if the IP restriction is OK or no IP restrictions have been set
					--->
				<cfif (q_select_ip_restrictions.recordcount is 0) OR (a_bol_allowed is true)>
				
				</cfif>
				
		<cfelse>
			<!--- we do NOT have any restrictions ... allow login now! --->
			<cfset a_bol_allowed = true>
		</cfif> --->
		
		<cfreturn a_bol_allowed>
	</cffunction>
	
	<!--- check if the IP is allowed (range ...) --->
	<cffunction access="private" name="CompareIPAddresses" output="true" returntype="boolean">
		<cfargument name="allowedip" type="string" required="true" default="">
		<cfargument name="remoteaadr" type="string" required="true" default="">
	
		<cfset a_struct_allowed = StructNew()>
		<cfset a_struct_remoteaddr = StructNew()>
		
		<cfset ii = 0>
		
		<cfloop index="a_str_part" list="#remoteaadr#" delimiters=".">
			<cfset ii = ii + 1>
			<cfloop condition="#len(a_str_part)# lt 3">
				<cfset a_str_part = "0"&a_str_part>
			</cfloop>
			
			<cfset a_struct_remoteaddr[ii] = a_str_part>
		</cfloop>
		
		<cfset ii = 0>
		
		<cfloop index="a_str_part" list="#allowedip#" delimiters=".">
			<cfset ii = ii + 1>
			
			<cfif a_str_part is "x">
				<!--- variable ... set the whole part to the variable string --->
				<cfset a_str_part = "xxx">
			</cfif>
			
			<cfloop condition="#len(a_str_part)# lt 3">
				<cfset a_str_part = "0"&a_str_part>
			</cfloop>
			
	
			<cfloop index="a_int_jj" from="1" to="#len(a_str_part)#" step="1">
				<cfif Mid(a_str_part, a_int_jj, 1) is "x">
					<!--- variable part! set also in the remote address ... --->
					
					<cfset a_str_other_part = a_struct_remoteaddr[ii]>
					<cfset a_str_new_other_part = "">
					
					<cfloop index="a_int_kk" from="1" to="#len(a_str_other_part)#">
						<cfif a_int_kk is a_int_jj>
							<cfset a_str_new_other_part = a_str_new_other_part & "x">
						<cfelse>
							<cfset a_str_new_other_part = a_str_new_other_part & Mid(a_str_other_part, a_int_kk, 1)>
						</cfif>
					</cfloop>
					
					<cfset a_struct_remoteaddr[ii] = a_str_new_other_part> 
					
				</cfif>
			</cfloop>
			
			<cfset a_struct_allowed[ii] = a_str_part>
		</cfloop>	
		
		<cfset a_str_allowed = "">
		
		<cfloop index="ii" from="1" to="#StructCount(a_struct_allowed)#">
			<cfset a_str_allowed = a_str_allowed & a_struct_allowed[ii]>
		</cfloop>
		
		<cfset a_str_remote = "">
		
		<cfloop index="ii" from="1" to="#StructCount(a_struct_remoteaddr)#">
			<cfset a_str_remote = a_str_remote & a_struct_remoteaddr[ii]>
		</cfloop>	
		
		<cfif comparenocase(a_str_remote, a_str_allowed) is 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>	
	
	<cffunction access="public" name="CheckHashLogin" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true">
		<cfargument name="pwd" type="string" required="true">
		
		<cfinclude template="queries/q_select_hased_login.cfm">
		
		<cfreturn (q_select_hased_login.recordcount IS 1)>
	</cffunction>
	
	<cffunction access="public" name="CheckHasLoginAndGetImportantUserdata" returntype="struct">
		<cfargument name="username" type="string" required="true">
		<cfargument name="pwd" type="string" required="true">
		
		<cfset var stReturn = StructNew()>
		<cfset var LoadImportantUserdata = StructNew() />
		<cfset var a_bol_login = false />
		
		<cfinvoke component="cmp_check_login" method="CheckHashLogin" returnvariable="a_bol_login">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="pwd" value="#arguments.pwd#">
		</cfinvoke>
		
		<cfset stReturn.a_bol_return = a_bol_login>
		
		<cfif a_bol_login>
			<!--- load important userdata --->
			<cfset LoadImportantUserdata.username = arguments.username>
			<cfinclude template="queries/q_select_important_userdata.cfm">
			
			<cfset stReturn.q_select_important_userdata = q_select_important_userdata>
		</cfif>
		
		
		<cfreturn stReturn>
		
	</cffunction>

</cfcomponent>

