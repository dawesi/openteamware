
<cfcomponent>
	
	<!--- create a comment ... --->
	<cffunction access="public" name="InsertComment" output="false" returntype="string">
	
	
	</cffunction>
	
	<!--- load comments ... --->
	<cffunction access="public" name="GetComments" output="false" returntype="struct">
		<!--- security context --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- servicekey --->
		<cfargument name="servicekey" type="string" required="true">
		<!--- objectkey --->
		<cfargument name="objectkey" type="string" required="true">
		
		
		<cfinclude template="queries/q_select_comments.cfm">
		
		<cfset stReturn = StructNew()>
		
		<cfset stReturn.q_select_comments = q_select_comments>
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- load comments ... without security permission check --->
	<cffunction access="public" name="GetCommentsInternal" output="false" returntype="struct">
		<!--- servicekey --->
		<cfargument name="servicekey" type="string" required="true">
		<!--- objectkey --->
		<cfargument name="objectkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_comments.cfm">
		
		<cfset stReturn = StructNew()>
		<cfset stReturn.q_select_comments = q_select_comments>
		<cfreturn stReturn>
	</cffunction>	

</cfcomponent>