<cfquery name="q_delete_old_data"  datasource="#GetDSName('DELETE')#">
DELETE FROM
	redata
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
</cfquery>

<cfquery name="q_insert_contact" datasource="#GetDSName('INSERT')#">
INSERT INTO
	redata
	(
	entrykey,
	dt_created,
	
	firstname,
	surname,
	title,
	sex,
	
	<cfif Len(arguments.birthday) GT 0 AND isDate(arguments.birthday)>
	birthday,
	</cfif>
	
	email_prim,
	email_adr,
	
	company,
	department,
	aposition,
	
	b_street,
	b_zipcode,
	b_city,
	b_country,
	b_telephone,
	b_fax,
	b_mobile,
	b_url,
	
	p_street,
	p_zipcode,
	p_city,
	p_country,
	p_telephone,
	p_fax,
	p_mobile,
	p_url,
	skypeusername,
	notice
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetUTCTime(now())#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.surname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sex#">,
	
	<cfif Len(arguments.birthday) GT 0 AND isDate(arguments.birthday)>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(ParseDateTime(arguments.birthday))#">,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_prim#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_adr#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.position#">,			
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_street#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_zipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_city#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_country#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_telephone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_fax#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_mobile#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.b_url#">,						
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_street#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_zipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_city#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_country#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_telephone#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_fax#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_mobile#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.p_url#">,														
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.skypeusername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.notice#">
	)
;	
</cfquery>