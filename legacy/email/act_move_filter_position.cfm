<!--- //

	move the position of a filter ...
	
	<io>
		<in>
			<param name="direction" scope="url" type="string" default="up">
				<description>
				the direction ... up or down
				</description>
			</param>
		</in>
		
		<out>
			<param name="id" scope="url" type="numeric" default="0">
				<description>
				the id of the entry
				</description>
			</param>	
		</out>	
	</io>
	
	// --->
	
<cfparam name="url.direction" type="string" default="up">
<cfparam name="url.id" type="numeric" default="0">

<cfset SelectSingleFilterRequest.id = url.id>
<cfinclude template="queries/q_select_single_filter.cfm">

<cfif q_select_single_filter.recordcount is 0>
	<!--- no filter found ... --->
	<cflocation addtoken="no" url="index.cfm?action=filter">
</cfif>

<cfif url.direction is "up">
	<!--- move up ... --->
	
	<!--- select the filter one higher than the current one ... --->
	<cfquery maxrows="1" name="q_select_higher" datasource="#request.a_str_db_mailusers#">
	SELECT id,aposition FROM filter
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (aposition < <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_single_filter.aposition)#">)
	ORDER BY aposition DESC;
	</cfquery>
	
	<cfif q_select_higher.recordcount is 0>
		<!--- no higher filter ... --->
		<cflocation addtoken="no" url="index.cfm?action=filter">
	</cfif>
	
	<!--- exchange positions ... --->
	<cfquery name="q_update_original" datasource="#request.a_str_db_mailusers#">
	UPDATE filter SET aposition = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_higher.aposition#">
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">);
	</cfquery>

	<cfquery name="q_update_old" datasource="#request.a_str_db_mailusers#">
	UPDATE filter SET aposition = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_single_filter.aposition#">
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_higher.id#">);
	</cfquery>	
	
<cfelse>
	<!--- move downwards ... --->
	
	<!--- select the filter one higher than the current one ... --->
	<cfquery maxrows="1" name="q_select_lower" datasource="#request.a_str_db_mailusers#">
	SELECT id,aposition FROM filter
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (aposition > <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_single_filter.aposition)#">)
	ORDER BY aposition;
	</cfquery>
	
	<cfif q_select_lower.recordcount is 0>
		<!--- no higher filter ... --->
		<cflocation addtoken="no" url="index.cfm?action=filter">
	</cfif>
	
	<!--- exchange positions ... --->
	<cfquery name="q_update_original" datasource="#request.a_str_db_mailusers#">
	UPDATE filter SET aposition = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_lower.aposition#">
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">);
	</cfquery>

	<cfquery name="q_update_old" datasource="#request.a_str_db_mailusers#">
	UPDATE filter SET aposition = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_single_filter.aposition#">
	WHERE (email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_lower.id#">);
	</cfquery>
</cfif>

<cfinvoke component="/components/email/cmp_filter" method="CreateProcmailconfig" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<!--- redirect ... --->
<cflocation addtoken="no" url="index.cfm?action=filter">