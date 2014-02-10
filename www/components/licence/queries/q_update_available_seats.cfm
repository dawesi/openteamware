

<cfquery name="q_select_record_available" datasource="#request.a_str_db_users#">
SELECT
	totalseats,availableseats,inuse
FROM
	licencing
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
;
</cfquery>

<cfif q_select_record_available.recordcount IS 0>
	<!--- insert new --->
	
	<cfquery name="q_insert_available_seats" datasource="#request.a_str_db_users#">
	INSERT INTO
		licencing
		(
		companykey,
		productkey,
		availableseats,
		totalseats
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addseats#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addseats#">
		)
	;		
	</cfquery>

<cfelse>
	<!--- update availableseats now --->
	
	<!---<cfif arguments.addseats GT 0>
		<cfset a_int_new_number_totalseats = q_select_record_available.totalseats + arguments.addseats>
	<cfelse>
		<cfset a_int_new_number_totalseats = q_select_record_available.totalseats>
	</cfif>--->
	
	<!--- add the number of seats that are added ... --->
	<cfset a_int_new_number_availableseats = q_select_record_available.availableseats + arguments.addseats>
	<cfset a_int_new_number_totalseats = q_select_record_available.totalseats + arguments.addseats>
	
	<cfquery name="q_insert_available_seats" datasource="#request.a_str_db_users#">
	UPDATE
		licencing
	SET
	
		<cfif arguments.comingfromshop IS 1>
			<!--- coming from the shop ... update totalseats too ... --->
			totalseats = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_number_totalseats#">,
		</cfif>
		
		availableseats = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_number_availableseats#">
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
		AND
		productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
	;		
	</cfquery>	

</cfif>