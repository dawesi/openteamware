<!--- //

	check if the session key is OK
	
	if yes, return the userid
	
	// --->
	
<cfcomponent>
	<cffunction access="public" name="GetUseridFromSessionKey" output="false" returntype="struct">
		<cfargument name="sessionkey" required="true" type="string" default="">
		
		<cfreturn StructNew()>
	
	</cffunction>
</cfcomponent>