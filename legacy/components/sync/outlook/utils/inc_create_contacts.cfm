
<cfloop from="1" to="#arraylen(a_array_return)#" index="ii">

	<cfset a_struct_element = a_array_return[ii]>
	
	<!--- parse dates --->	
	<cfset a_dt_lastmod = LsParseDateTime(a_struct_element.lastmodificationtime)>
	
	<cfif Len(trim(a_struct_element.birthday)) gt 0 AND IsDate(a_struct_element.birthday)>
		<cfset a_dt_birthday = LsParseDateTime(a_struct_element.birthday)>
	<cfelse>
		<cfset a_dt_birthday = ''>
	</cfif>	
	
	<cfset a_str_ibcc_entrykey = CreateUUID()>
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#session.stUserSettings#">	
		<cfinvokeargument name="entrykey" value="#a_str_ibcc_entrykey#">
		<cfinvokeargument name="firstname" value="#a_struct_element.firstname#">
		<cfinvokeargument name="surname" value="#a_struct_element.surname#">
		<cfinvokeargument name="title" value="#a_struct_element.title#">
		<cfinvokeargument name="company" value="#a_struct_element.companyname#">
		<cfinvokeargument name="department" value="#a_struct_element.department#">
		<cfinvokeargument name="position" value="#a_struct_element.jobtitle#">
		<cfinvokeargument name="email_prim" value="#a_struct_element.email1address#">
		
		<cfif IsDate(a_dt_birthday)>
			<cfinvokeargument name="birthday" value="#a_dt_birthday#">
		</cfif>
		
		<cfinvokeargument name="categories" value="#Mid(a_Struct_element.categories, 1, 250)#">
		<cfinvokeargument name="b_street" value="#a_struct_element.businessaddressstreet#">
		<cfinvokeargument name="b_city" value="#a_struct_element.businessaddresscity#">
		<cfinvokeargument name="b_zipcode" value="#a_struct_element.businessaddresspostalcode#">
		<cfinvokeargument name="b_country" value="#a_struct_element.businessaddresscountry#">
		<cfinvokeargument name="b_telephone" value="#a_struct_element.businesstelephonenumber#">
		<cfinvokeargument name="b_fax" value="#a_struct_element.businessfaxnumber#">
		<cfinvokeargument name="b_mobile" value="#a_Struct_element.MobileTelephoneNumber#">
		<cfinvokeargument name="b_url" value="#a_Struct_element.webpage#">
		<cfinvokeargument name="p_street" value="#a_struct_element.homeaddressstreet#">
		<cfinvokeargument name="p_city" value="#a_struct_element.homeaddresscity#">
		<cfinvokeargument name="p_zipcode" value="#a_struct_element.homeaddresspostalcode#">
		<cfinvokeargument name="p_country" value="#a_struct_element.homeaddresscountry#">
		<cfinvokeargument name="p_telephone" value="#a_struct_element.hometelephonenumber#">
		<cfinvokeargument name="p_fax" value="#a_struct_element.homefaxnumber#">
		<cfinvokeargument name="p_mobile" value="#a_Struct_element.Home2TelephoneNumber#">
		<cfinvokeargument name="notice" value="#a_struct_element.body#">
	</cfinvoke>

	<cfquery name="q_insert_meta_data" datasource="#request.a_str_db_tools#">
	INSERT INTO
		addressbook_outlook_data
		(
		program_id,
		addressbookkey,
		outlook_id,
		lastupdate
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_ibcc_entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.entryid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_lastmod)#">
		)
	;
	</cfquery>
		
</cfloop>