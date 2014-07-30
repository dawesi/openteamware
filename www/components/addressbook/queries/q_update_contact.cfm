<!--- //

	Module:		Address Book
	Function:	UpdateContact
	Description:Update a contac


// --->

<cfquery name="q_update_contact">
UPDATE
	addressbook
SET
	<cfif arguments.updatelastmodified>
		<!--- update last modified ... --->
		dt_lastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	</cfif>

	lasteditedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">

	<cfif StructKeyExists(arguments.newvalues, 'userkey') AND (Len(arguments.newvalues.userkey) GT 0)>
		<!--- someone wants to take over the ownership ... --->

		<cfif stReturn_rights.managepermissions is true>
		,userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.userkey#">
		</cfif>

	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'birthday')>

		<cfif isDate(arguments.newvalues.birthday)>

			<!--- try to convert date --->
			<cftry>
				<cfif FindNoCase('{ts', arguments.newvalues.birthday) IS 0>
					<cfset a_dt_birthday = CreateOdbcDateTime(LSParseDateTime(arguments.newvalues.birthday))>
				<cfelse>
					<cfset a_dt_birthday = CreateOdbcDateTime(arguments.newvalues.birthday)>
				</cfif>

				<cfcatch type="any">
					<!--- something failed ... create empty string --->
					<cfset a_dt_birthday = ''>
				</cfcatch>
			</cftry>

			<cfif IsDate(a_dt_birthday)>
				,birthday = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_birthday#">
			</cfif>

			<!---<cfif FindNoCase('{ts', arguments.newvalues.birthday) IS 0>
			<!--- no ready date --->
			,birthday = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(LSParseDateTime(arguments.newvalues.birthday))#">
			<cfelse>
			,birthday = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.birthday)#">
			</cfif>--->

		<cfelse>
			<!--- empty value? --->
			,birthday = NULL
		</cfif>
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'dt_lastcontact') AND (isDate(arguments.newvalues.dt_lastcontact) IS TRUE)>
	,dt_lastcontact = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.dt_lastcontact)#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'dt_lastsmssent') AND (isDate(arguments.newvalues.dt_lastsmssent) IS TRUE)>
	,dt_lastsmssent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.newvalues.dt_lastsmssent)#">
	</cfif>

<!--- 	<cfif StructKeyExists(arguments.newvalues, 'archiveentry')>
	,archiveentry = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.archiveentry#">
	</cfif>	 --->

	<cfif StructKeyExists(arguments.newvalues, 'firstname')>
	,firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.firstname#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'update_remoteedit_last_edited') AND arguments.newvalues.update_remoteedit_last_edited>
		,dt_remoteedit_last_update = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'categories')>
	,categories = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.categories#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'criteria')>
	,criteria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.criteria#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'notice')>
	,notice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.notice#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'surname')>
	,surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.surname#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'sex')>
	,sex = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.sex#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'title')>
	,title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.title#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'email_prim')>
	,email_prim = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.email_prim#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'email_adr')>
	,email_adr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.email_adr#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'company')>
	,company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.company#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'department')>
	,department = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.department#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'aposition')>
	,aposition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.aposition#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_url')>
	,b_url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_url#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_telephone')>
	,b_telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_telephone#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_telephone_2')>
	,b_telephone_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_telephone_2#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_fax')>
	,b_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_fax#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_mobile')>
	,b_mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_mobile#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_street')>
	,b_street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_street#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_zipcode')>
	,b_zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_zipcode#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_city')>
	,b_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_city#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'b_country')>
	,b_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.b_country#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_url')>
	,p_url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_url#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_telephone')>
	,p_telephone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_telephone#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_fax')>
	,p_fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_fax#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_mobile')>
	,p_mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_mobile#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_street')>
	,p_street = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_street#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_zipcode')>
	,p_zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_zipcode#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_city')>
	,p_city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_city#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'p_country')>
	,p_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.p_country#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'skypeusername')>
	,skypeusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.skypeusername#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'lang')>
	,lang = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(arguments.newvalues.lang, 1, 2)#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'contacttype')>
	,contacttype = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.newvalues.contacttype)#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'ownfield1')>
	,ownfield1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.ownfield1#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'ownfield2')>
	,ownfield2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.ownfield2#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'ownfield3')>
	,ownfield3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.ownfield3#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'ownfield4')>
	,ownfield4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.ownfield4#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'parentcontactkey')>
	,parentcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.parentcontactkey#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'superiorcontactkey')>
	,superiorcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newvalues.superiorcontactkey#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'employees') AND (Len(arguments.newvalues.employees) GT 0)>
	,employees = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.employees#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'photoavailable')>
	,photoavailable = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.photoavailable#">
	</cfif>

	<cfif StructKeyExists(arguments.newvalues, 'nace_code')>
		<cfif Len(arguments.newvalues.nace_code) GT 0>
			,nace_code = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.newvalues.nace_code#">
		<cfelse>
			,nace_code = NULL
		</cfif>
	</cfif>

WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>