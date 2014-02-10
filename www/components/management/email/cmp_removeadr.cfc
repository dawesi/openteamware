<!--- //

	remove an address
	
	// --->
	
<cfcomponent>

	<cffunction access="public" name="RemoveEmailAddress" output="false" returntype="boolean">
		<cfargument name="id" type="numeric" required="false" default="0">
		<cfargument name="emailadr" type="string" required="true" default="">
	
	</cffunction>

</cfcomponent>