<cfcomponent>
	<cffunction access="remote" name="GetWorkgroups" output="false" returntype="array">
		<cfargument name="entrykey" type="string" required="true" default="">
		
		<cfset a_arr_return = ArrayNew(1)>
		<cfset a_struct = StructNew()>
		
		<cfset a_struct.name = "Entwicklung">
		<cfset a_struct.id = 123>
		
		<cfset a_arr_return[1] = a_struct>		
		
		<cfreturn a_arr_return>
	
	</cffunction>
</cfcomponent>