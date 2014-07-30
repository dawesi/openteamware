<cfcomponent>


	<cffunction access="public" name="GetLangValue" output="false" returntype="string" displayname="Load a localized version of a string">
		<cfargument name="entryname" type="string" required="true" default="">
		<cfargument name="languagenumber" type="numeric" required="true" default="0">
		
		<cfset var q_select = 0 />
		<cfset var a_str_value = '' />
		
		<cfquery name="q_select">
		SELECT
			entryvalue
		FROM
			langdata
		WHERE
			entryid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entryname#">
			AND
			langno = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.languagenumber#">
		;
		</cfquery>

	
		<cfset a_str_value = q_select.entryvalue />
		
		<cfreturn a_Str_value />
	
	</cffunction>

</cfcomponent>