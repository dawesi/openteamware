<!--- //

	Cmp:		Address Book
	Function:	CreateContact
	Description:Create and insert a new contact
	
	Header:		

// --->

<cfquery name="q_insert_contact" datasource="#GetDSName('INSERT')#">
INSERT INTO
	addressbook
	(
	entrykey,
	userkey,
	contacttype,
	parentcontactkey,
	superiorcontactkey,
	createdbyuserkey,
	lasteditedbyuserkey,
	dt_created,
	dt_lastmodified,
	
	firstname,
	surname,
	title,
	sex,
	
	<cfif (Len(arguments.birthday) GT 0) AND
		isDate(arguments.birthday)>
	birthday,
	</cfif>
	
	email_prim,
	email_adr,
	categories,
	criteria,
	
	company,
	department,
	aposition,
	
	b_street,
	b_zipcode,
	b_city,
	b_country,
	b_telephone,
	b_telephone_2,
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
	
	ownfield1,
	ownfield2,
	ownfield3,
	ownfield4,
	
	notice,
	skypeusername,
	lang,
	nace_code
	
	<cfif Len(arguments.employees) GT 0>
		,employees
	</cfif>
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contacttype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentcontactkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.superiorcontactkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetUTCTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetUTCTime(now())#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.firstname)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.surname)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.title)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sex#">,
	
	<cfif Len(arguments.birthday) GT 0 AND isDate(arguments.birthday)>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(ParseDateTime(arguments.birthday))#">,
	</cfif>
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(arguments.email_prim)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(arguments.email_adr)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.categories)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.criteria#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.company)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.department)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.position)#">,			
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_street)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_zipcode)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_city)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_country)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_telephone)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_telephone_2)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_fax)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_mobile)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.b_url)#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_street)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_zipcode)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_city)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_country)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_telephone)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_fax)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_mobile)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.p_url)#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.ownfield1)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.ownfield2)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.ownfield3)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.ownfield4)#">,
	
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.notice)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.skypeusername)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.language)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.nace_code)#">
	
	<cfif Len(arguments.employees) GT 0>
		,<cfqueryparam cfsqltype="cf_sql_integer" value="#Val(arguments.employees)#">
	</cfif>
	)
;	
</cfquery>

