<!--- //

	Module:	SERVICE
	Description: 
	

// --->

<cfset a_dt_disabled = DateAdd('d', -60, Now()) />

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	companyname,email,dt_disabled,dt_created,entrykey,email,customerid
FROM
	companies
WHERE
	disabled = 1
	AND
	dt_disabled < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_disabled)#">
ORDER BY
	dt_disabled
;
</cfquery>

<cfdump var="#q_select_companies#">

<cfloop query="q_select_companies">
	
	<cfquery name="q_select_accounts" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(entrykey) AS count_id
	FROM
		users
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
	;
	</cfquery>
	
	<cfif q_select_accounts.count_id IS 0>
		<cfoutput>
		#q_select_companies.companyname#<br>
		</cfoutput>
		
		
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
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">,
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
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		;
		</cfquery>
		
		<cfquery name="q_delete_company" datasource="#request.a_str_db_users#">
		DELETE FROM
			companies
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		;
		</cfquery>
		
	</cfif>

</cfloop>


