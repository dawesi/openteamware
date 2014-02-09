<!--- //

	Module:	SERVICE
	Description: 
	
	
	
	select all sub resellers ... 
	
// --->

<cfquery name="q_select_all_resellers" datasource="#request.a_Str_db_users#">
SELECT
	entrykey,companyname,delegaterights,parentkey,domains,emailadr,
	isdistributor,isprojectpartner,issystempartner,contractingparty,
	default_settlement_type,allow_modify_settlement_type
FROM
	reseller
;
</cfquery>

<cfquery name="q_select_sub_resellers" datasource="#request.a_Str_db_users#">
SELECT
	entrykey,companyname,delegaterights,parentkey,domains,emailadr,isdistributor,isprojectpartner,issystempartner,contractingparty,
	default_settlement_type,allow_modify_settlement_type
FROM
	reseller
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_reseller_entry_key#">
	AND
	contractingparty = 1
ORDER BY
	companyname
;
</cfquery>

	<!---
	<cfquery name="q_select_sub_sub_reseller" datasource="#request.a_str_db_users#">
	SELECT
		companyname,entrykey,delegaterights,parentkey,domains,emailadr,isdistributor,isprojectpartner,issystempartner,contractingparty
	FROM
		reseller
	WHERE
		parentkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_sub_resellers.entrykey)#">)
	ORDER BY
		companyname
	;
	</cfquery>--->

<cfloop query="q_select_sub_resellers">

	<!--- level one ... --->

	

	<cfset AddSelectQuery.delegaterights = q_select_sub_resellers.delegaterights>

	<cfset AddSelectQuery.Query = q_select_sub_resellers>

	<cfset AddSelectQuery.level = 1>

	<cfinclude template="inc_add_v_query.cfm">

	


	<cfquery name="q_select_sub_sub_reseller" dbtype="query">
	SELECT
		companyname,entrykey,delegaterights,parentkey,domains,emailadr,
		isdistributor,isprojectpartner,issystempartner,contractingparty,
		default_settlement_type,allow_modify_settlement_type
	FROM
		q_select_all_resellers
	WHERE
		parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_sub_resellers.entrykey#">
	ORDER BY
		companyname
	;
	</cfquery>	
	

	<cfloop query="q_select_sub_sub_reseller">

		<!--- level two ... --->

		

		<cfset AddSelectQuery.delegaterights = q_select_sub_resellers.delegaterights>

		<cfset AddSelectQuery.Query = q_select_sub_sub_reseller>

		<cfset AddSelectQuery.level = 2>
		
		<cfset AddSelectQuery.emailadr = q_select_sub_sub_reseller.emailadr>

		<cfinclude template="inc_add_v_query.cfm">

			
		<cfquery name="q_select_sub_sub_sub_reseller" dbtype="query">
		SELECT
			companyname,entrykey,delegaterights,parentkey,domains,emailadr,isdistributor,
			isprojectpartner,issystempartner,contractingparty,
			default_settlement_type,allow_modify_settlement_type
		FROM
			q_select_all_resellers
			<!---reseller--->
		WHERE
			parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_sub_sub_reseller.entrykey#">
		ORDER BY
			companyname
		;		
		</cfquery>

		

		<cfloop query="q_select_sub_sub_sub_reseller">

		<!--- level three ... and over ... --->

			<cfset AddSelectQuery.emailadr = q_select_sub_sub_reseller.emailadr>

			<cfset AddSelectQuery.DelegateRights = q_select_sub_sub_reseller.delegaterights>

			<cfset AddSelectQuery.Query = q_select_sub_sub_sub_reseller>

			<cfset AddSelectQuery.level = 3>

			<cfinclude template="inc_add_v_query.cfm">

				<cfquery name="q_select_sub_sub_sub_reseller_4" datasource="#request.a_str_db_users#">
		
				SELECT companyname,entrykey,delegaterights,parentkey,domains,emailadr,isdistributor,
				isprojectpartner,issystempartner,contractingparty,
				default_settlement_type,allow_modify_settlement_type
				FROM reseller
		
				WHERE parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_sub_sub_sub_reseller.entrykey#">
				
				ORDER BY
				companyname;
		
				</cfquery>
				
					<cfloop query="q_select_sub_sub_sub_reseller_4">

					<!--- level three ... and over ... --->
			
						<cfset AddSelectQuery.emailadr = q_select_sub_sub_sub_reseller_4.emailadr>
			
						<cfset AddSelectQuery.DelegateRights = q_select_sub_sub_sub_reseller_4.delegaterights>
			
						<cfset AddSelectQuery.Query = q_select_sub_sub_sub_reseller_4>
			
						<cfset AddSelectQuery.level = 4>
			
						<cfinclude template="inc_add_v_query.cfm">
						
					</cfloop>

		</cfloop>

	

	

	</cfloop>



</cfloop>




