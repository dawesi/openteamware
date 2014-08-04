<!--- //

	Module:		Email
	Action:		Filter components
	Description:


// --->
<cfcomponent displayname="FilterComponents">

<cfinclude template="/common/app/app_global.cfm">

	<!--- create the filter config (procmail file ...) --->
	<cffunction access="public" name="CreateProcmailconfig" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true" default="">

		<cfset arguments.username = lcase(arguments.username)>

		<cfhttp url="#request.a_str_url_generateprocmailconfigurl##urlencodedformat(arguments.username)#" method="get" resolveurl="no"></cfhttp>

		<cfreturn true>

	</cffunction>


</cfcomponent>

