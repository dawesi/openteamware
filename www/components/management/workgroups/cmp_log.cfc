<cfcomponent>

	<!--- 
	
		load all modifications made to a workgroup entry
		
		
		--->
		
	<cffunction access="public" name="CreateLogEntry" output="false" returntype="boolean">
		<!--- service key ... --->
		<cfargument name="servicekey" type="string" default="" required="true">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" default="" required="true">
		<!--- item key --->
		<cfargument name="itemkey" type="string" default="" required="true">
		<!--- action done (write,create,edit,delete ...) --->
		<cfargument name="action" type="string" default="" required="true">
		
		<!--- insert into database ... --->
		
	
	
	
		<cfreturn true>
	
	</cffunction>
	
	<!--- load last N entries ... --->
	<cffunction access="public" name="GetLogEntries" output="false" returntype="query">
		<!--- service key ... --->
		<cfargument name="servicekey" type="string" default="" required="true">
		<!--- item key --->
		<cfargument name="itemkey" type="string" default="" required="true">
		<!--- number of records to load --->	
		<cfargument name="maxrows" type="numeric" default="10" required="true">
		
		<!--- load data ... --->
		

		<cfreturn QueryNew("userkey,dt_action,action")>	
	</cffunction>
	
	<!--- delete all entries ... --->
	<cffunction access="public" name="ClearLog" output="false" returntype="boolean">
		<!--- service key ... --->
		<!--- item key --->
		
		<cfreturn true>
	
	</cffunction>

</cfcomponent>