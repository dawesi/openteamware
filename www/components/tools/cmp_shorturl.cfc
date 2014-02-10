<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	
	<cffunction access="public" name="CreateShortLink" returntype="string" output="false">
		<cfargument name="userkey" type="string" default="" required="no">
		<cfargument name="href" type="string" required="yes">
		<cfargument name="daysvalid" type="numeric" default="365" required="no">
		
		<cfset a_dt_validuntil = DateAdd('d', arguments.daysvalid, Now())>
		
		<cfset sEntrykey = Right(ReplaceNoCase(Createuuid(), "-", "", "ALL"), 10)>
		
		<cfinclude template="queries/q_insert_shortlink.cfm">
		
		<cfreturn 'http://www.openTeamWare.com/shorturl/?'&sEntrykey>
	</cffunction>
</cfcomponent>