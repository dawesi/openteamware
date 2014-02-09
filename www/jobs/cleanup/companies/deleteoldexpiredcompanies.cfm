<cfsetting requesttimeout="2000">

<!--- //

	delete all disabled customers
	which are disabled now for more than 10 days ...
	
	// --->
<cfinclude template="/common/scripts/script_utils.cfm">
	
<cfset a_dt_disabled = DateAdd('d', -60, Now()) />
	
<cfquery name="q_select_companies" datasource="#request.a_str_db_users#" maxrows="15">
SELECT
	companyname,email,dt_disabled,entrykey,email,customerid
FROM
	companies
WHERE
	disabled = 1
	AND
	dt_disabled < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_disabled)#">
ORDER BY
	dt_disabled
LIMIT
	50
;
</cfquery>

<cfdump var="#q_select_companies#">

<cfif q_select_companies.recordcount GT 0>
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="companies deleted" type="html">
		<cfdump var="#q_select_companies#">
	</cfmail>
</cfif>

<cfoutput query="q_select_companies">
	
	<cfset a_str_companykey = q_select_companies.entrykey>

	<!--- insert into newsletter table ... --->
	<cfif ExtractEmailAdr(q_select_companies.email) NEQ ''>
		
		<cftry>
		<cfquery name="q_insert_nl" datasource="mynewsletter">
		INSERT INTO
			ibinterestedparties
			(
			companyname,
			oldcustomerid,
			oldcompanykey,
			secretkey,
			dt_created,
			emailadr
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.companyname#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_companies.customerid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(CreateUUID(), 1, 10)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDAteTime(now())#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(q_select_companies.email)#">
			)
		;
		</cfquery>
		<cfcatch type="any">
		
		</cfcatch>
		</cftry>
		
	</cfif>
	
	<!--- move old data --->
	<cfquery name="q_move_data" datasource="#request.a_str_db_users#">
	INSERT INTO
		oldcompanies
	SELECT
		*
	FROM
		companies
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">
	;
	</cfquery>
	
	
	<!--- delete the trash ... --->
	<cfquery name="q_select_accounts" datasource="#request.a_str_db_users#">
	SELECT
		entrykey,username
	FROM
		users
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">
	;
	</cfquery>
	
	<cfloop query="q_select_accounts">
		#q_select_accounts.username#<br>
		
		<cfinvoke component="#application.components.cmp_user#" method="DeleteUser" returnvariable="a_bol_return">
			<cfinvokeargument name="entrykey" value="#q_select_accounts.entrykey#">
			<cfinvokeargument name="companykey" value="#a_str_companykey#">
		</cfinvoke>
	</cfloop>
	
	<!--- delete now the company ... --->
	<cfquery name="q_delete_company" datasource="#request.a_str_db_users#">
	DELETE FROM
		companies
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">
	;
	</cfquery>	
</cfoutput>