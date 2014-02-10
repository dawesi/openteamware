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

	<!--- create a filter --->
	<cffunction access="public" name="CreateFilter" output="false" returntype="boolean">
		<cfargument name="filtername" type="string" required="true" default="">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="filteraction" type="numeric" required="true" default="0">
		<cfargument name="filterparam" type="string" required="true" default="">
		<cfargument name="comparisonfield" type="numeric" required="true" default="0">
		<cfargument name="comparison" type="numeric" required="true" default="0">
		<cfargument name="stoponsuccess" type="numeric" required="true" default="0">
		<cfargument name="comparisonparam" type="string" required="true" default="">
		<cfargument name="antispamfilter" type="numeric" required="false" default="0">
		
		<cfset var a_int_position = 0 />
		<cfset var q_select_max_position = 0 />
		<cfset var q_insert_filter = 0 />
		
		<!--- select new max position id --->
		<cfquery name="q_select_max_position" datasource="#request.a_str_db_mailusers#">
		SELECT
			MAX(aposition) AS max_position
		FROM
			filter
		WHERE
			(email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">)
		;
		</cfquery>
		
		<cfset a_int_position = val(q_select_max_position.max_position) + 1>
		
		<!--- insert now --->
		<cfquery name="q_insert_filter" datasource="#request.a_str_db_mailusers#">
		INSERT INTO
			filter
			(email,enabled,aposition,stoponsuccess,filtertype,filtername,parameter,comparison,
			comparisonparm,comparisonfield,userdefined,antispamfilter)
		VALUES
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_position#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stoponsuccess#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filteraction#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filtername#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterparam#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comparison#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comparisonparam#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comparisonfield#">,
			1,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.antispamfilter#">)
		;		
		</cfquery>
		
		<cfreturn true>
	
	</cffunction>
	
	<!--- update filter ... --->
	<cffunction access="public" name="UpdateFilter" output="false" returntype="boolean">
		<cfargument name="filtername" type="string" required="true" default="">
		<cfargument name="id" type="numeric" required="true" default="0">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="filteraction" type="numeric" required="true" default="0">
		<cfargument name="filterparam" type="string" required="true" default="">
		<cfargument name="comparisonfield" type="numeric" required="true" default="0">
		<cfargument name="comparison" type="numeric" required="true" default="0">
		<cfargument name="stoponsuccess" type="numeric" required="true" default="0">
		<cfargument name="comparisonparam" type="string" required="true" default="">
		<cfargument name="antispamfilter" type="numeric" required="false" default="0">
		
		<cfset var q_update_filter = 0 />
		
		<cfquery name="q_update_filter" datasource="#request.a_str_db_mailusers#">
		UPDATE filter
		SET stoponsuccess = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stoponsuccess#">,
		filtertype = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filteraction#">,
		filtername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filtername#">,
		parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterparam#">,
		comparison = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comparison#">,
		comparisonparm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comparisonparam#">,
		comparisonfield = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comparisonfield#">,
		antispamfilter = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.antispamfilter#">
		WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">)
		AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">);	
		</cfquery>
		
		<cfreturn true>	
	</cffunction>

</cfcomponent>

