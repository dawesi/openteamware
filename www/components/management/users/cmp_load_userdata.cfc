<!--- //

	load several user data
	
	// --->
	
<cfcomponent output=false>

	<!---
	
		load the user data
		
		
		if entrykey <> '' then load using the entrykey ... otherwise using the userid
		
		--->
	
	<cffunction access="public" name="LoadUserData" output="false" returntype="struct">
		<cfargument name="userid" type="numeric" required="false" default="0">
		<cfargument name="entrykey" type="string" required="false" default="">
		<cfargument name="requestedfields" type="array" required="true" default="#ArrayNew(1)#">
		<cfargument name="fieldnames" type="string" default="" required="no">
		
		<cfset var stReturn = StructNew() />
		<cfset var LoadUserdataRequest = StructNew() />

		<!--- load data ... --->
		<cfset LoadUserdataRequest.userid = arguments.userid>
		<cfset LoadUserdataRequest.entrykey = arguments.entrykey>
		<cfinclude template="queries/q_load_userdata.cfm">
		
		<!--- check now if've got a result ... --->
		<cfif q_load_userdata.recordcount is 1>
			<cfset stReturn["result"] = "OK">
			
			<!--- ok, set data(query) ... --->			
			<cfset stReturn["query"] = q_load_userdata>
			
			<!--- load pop3 data too ... --->			
			
		<cfelse>
			<cfset stReturn["result"] = "ERROR">
		</cfif>
		
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- load all pop3 data ... --->
	<cffunction access="public" name="LoadEmailData" output="false" returntype="struct">
	
	
	</cffunction>

</cfcomponent>