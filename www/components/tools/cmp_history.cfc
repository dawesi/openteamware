<cfcomponent>

	<!---
	
		clickstream ...
		
		find easily a way back
		
		GET operations only!
		
		
		ONLY TO BE CALLED FROM THE WEBPAGE (users cgi and request scope)
		
		--->
		
	<cffunction access="public" name="CreateClickStreamEntry" output="false" returntype="boolean">
		<!--- pagename ... (localized) --->
		<cfargument name="pagename" type="string" default="" required="true">	
		<!--- user key --->
		<cfargument name="userkey" type="string" default="" required="true">
		<!--- service ... --->
		<cfargument name="servicekey" type="string" default="" required="false">
		<!--- href ... --->
		<cfargument name="href" type="string" default="" required="false">

		<cfset InsertClickstreamRequest = arguments>
			
		
		<!---<cflock name="lck_check_session_path_exists" timeout="3" type="readonly">
			<cfset tmp = StructKeyExists(request, "a_struct_navigation_history")>
		</cflock>
		
		<cfif tmp is false>
			<cfset session.a_struct_navigation_history = ArrayNew(1)>
			<cfset request.a_struct_navigation_history = session.a_struct_navigation_history>
		</cfif>
		
		<cfif ArrayLen(request.a_struct_navigation_history) gt 7>
			<cfset tmp = ArrayDeleteAt(request.a_struct_navigation_history, 1)>
		</cfif>	
		
		<cfif ArrayLen(request.a_struct_navigation_history) is 0>
			<cfset tmp = ArraySet(request.a_struct_navigation_history, 1, 1, StructNew())>
		</cfif>
		
		<cfset tmp = ArrayInsertAt(request.a_struct_navigation_history, 1, StructNew())>
		<cfset request.a_struct_navigation_history[1].pagename = arguments.pagename>
		<cfset request.a_struct_navigation_history[1].href = arguments.href>--->
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cgi">
		#cgi.script_name# #cgi.query_string#
		</cfmail>--->
		
		<!--- insert now ... --->
		<cfinclude template="queries/q_insert_clickstream.cfm">
		
		<cfreturn true>	
	
	</cffunction>
	
	
	<!--- load the clickstream and return an array for easier user ... --->
	<cffunction access="public" name="LoadClickStream" output="false" returntype="query">
		<!--- the user key ... --->
		<cfargument name="userkey" type="string" default="" required="true">
		<!--- maxrows ... default = 7 --->
		<cfargument name="maxrows" type="numeric" default="7" required="true">
		
		<cfset SelectClickStreamRequest = arguments>
		<cfinclude template="queries/q_select_clickstream.cfm">
		
		<!---<cfreturn q_select_clickstream>--->
		<cfreturn q_select_clickstream>
		
	</cffunction>
	
	<cffunction access="public" name="LoadClickStreamRawData" output="false" returntype="query">
	
		<cfreturn QueryNew('test')>
	</cffunction>

</cfcomponent>