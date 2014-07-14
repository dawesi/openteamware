<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	
	
	<!--- new functions ... --->
	
	<!--- check if an application is allowed to access data --->
	<cffunction access="public" name="IsAppAllowedToOperate" output="false" returntype="boolean">
		<cfargument name="applicationkey" type="string" required="yes">
		
		<cfreturn true>
	</cffunction>
	
	<!--- binding enabled (user hat zugestimmt?) --->
	<cffunction access="public" name="AppClientBindingActive" output="false" returntype="boolean">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="clientkey" type="string" required="yes">
		
		<cfreturn true>
	</cffunction>
	
	
	
	<!--- old --->

	<cffunction access="remote" name="GetUserPermissionsForObject" output="false" returntype="struct">
		<!--- userid --->
		<cfargument name="userid" type="numeric" default="0" required="true">	
		<!--- the specified service --->
		<cfargument name="service" type="string" default="common" required="true">
		<!--- object: f.e. table/categories/default: object --->
		<cfargument name="object" type="string" default="object" required="true">
		<!--- item ... mostly the ID / entrykey --->
		<cfargument name="item" type="string" default="" required="true">

		<cfset stReturn = StructNew()>
		
		<cfset stReturn["read"] = true>
		<cfset stReturn["write"] = true>
		<cfset stReturn["delete"] = true>		
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- return 0/1 --->
	<cffunction access="remote" name="CheckSimpleLogin" returntype="numeric" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="passwordmd5" type="string" required="true">
		
		<cftry>
		
		<cfinvoke component="/components/management/users/cmp_check_login" method="CheckLogin" returnvariable="stReturn">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.passwordmd5#">
			<cfinvokeargument name="remoteaddress" value="123">
		</cfinvoke>
				
		
		<cfif stReturn.ok IS TRUE>
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="error ws call" type="html">
				<cfdump var="#cfcatch#">
				<cfdump var="#application#">
			</cfmail>
			<cfreturn 1>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction access="remote" name="CheckLogin" returntype="struct" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="passwordmd5" type="string" required="true">
		
		<cfset stReturn = StructNew()>
		
		<cfset stReturn.result = true>
		<cfset stReturn.userkey = '123'>
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="remote" name="GetSecurityContext" returntype="struct" output="false">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="passwordmd5" type="string" required="true">
		
		<cfset stReturn = StructNew()>
		<cfset stReturn.context = '123'>
		<cfreturn stReturn>		
	</cffunction>
	
</cfcomponent>