<cfcomponent>
	<!--- return the raw companies data --->
	<cffunction name="GetCustomers" output="false" returntype="query">
		<cfargument name="filter" type="struct" required="no" default="#StructNew()#">
		
		<cfinclude template="queries/q_select_companies.cfm">
		
		<cfreturn q_select_companies>
	
	</cffunction>
	
	<cffunction access="public" name="Customers_GenerateReturnQuery" returntype="struct">
		<cfargument name="filter" type="struct" required="no" default="#StructNew()#">
		<!--- day / week / month / year --->
		<cfargument name="interval" type="string" default="day" required="no">
		<!--- type --->
		<cfargument name="stat_type" type="string" default="subscriptions" required="yes">
		<!--- start --->
		<cfargument name="date_start" type="date" default="#DateAdd('d', -90, Now())#" required="no">
		<!--- end --->
		<cfargument name="date_end" type="date" default="#Now()#" required="no">	
		
		<cfset var stReturn = StructNew()>
		
		<cfset arguments.date_start = CreateDate(Year(arguments.date_start), Month(arguments.date_start), Day(arguments.date_start))>
		<cfset arguments.date_end = CreateDate(Year(arguments.date_end), Month(arguments.date_end), Day(arguments.date_end))>
		
		<!--- month to check? --->
		<cfif arguments.interval IS 'month'>
			<cfset arguments.date_start = CreateDate(Year(arguments.date_start), Month(arguments.date_start), 1)>
			<cfset arguments.date_end = DateAdd('m', 1, arguments.date_start)>
		</cfif>
		
		<cfinclude template="queries/q_update_paid.cfm">
		
		<!--- get customers ... --->
		<cfset q_select_customers = GetCustomers(filter = arguments.filter)>
				
		<!--- create return query --->
		<cfinclude template="utils/inc_create_return_query.cfm">
		
		<cfswitch expression="#arguments.stat_type#">
			<cfcase value="subscriptions">
				<cfinclude template="queries/q_update_logins.cfm">
				<cfinclude template="utils/inc_create_stat_subscriptions.cfm">
			</cfcase>
			<cfcase value="sales">
				<cfinclude template="utils/inc_create_stat_sales.cfm">
			</cfcase>
			<cfcase value="logins">
				<cfinclude template="utils/inc_create_stat_logins.cfm">
			</cfcase>
			<cfcase value="demographics">
				<cfinclude template="utils/inc_create_stat_demographics.cfm">
			</cfcase>
			<cfcase value="demographics_zipcode">
				<cfinclude template="utils/inc_create_stat_demographics_zipcode.cfm">
			</cfcase>
			<cfcase value="referer">
				<cfinclude template="utils/inc_create_stat_referer.cfm">
			</cfcase>
			<cfcase value="usage">
				<cfinclude template="utils/inc_create_stat_usage.cfm">
			</cfcase>
			<cfcase value="http_referer">
				<cfinclude template="utils/inc_create_stat_http_referer.cfm">
				
				<cfset stReturn.q_top_referer = q_tmp_referer>
			</cfcase>
		</cfswitch>
		
		<cfset stReturn.q_return = q_return>
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="Invoices_GenerateReturnQuery" returntype="query">
		<cfreturn QueryNew('abc')>
	</cffunction>
</cfcomponent>