<cfset a_tc_lookup = GetTickCount()>
<cflog text="SEARCH REQUEST SYNCML ... Start " type="information" log="application" file="ib_syncml">

<cfset stReturn_contacts = request.a_ws_contacts.GetAllContacts(securitycontext = request.a_struct_security_context,
			usersettings = request.stUserSettings,
			orderby = '',
			loadoptions = StructNew(),
			fieldlist = a_str_field_list,
			filter = a_struct_filter,
			loadfulldata = true,
			loaddistinctcategories = false,
			convert_lastcontact_utc = false,
			crmfilter = StructNew(),
			loadowndatafields = false)> 
			
<cflog text="SEARCH REQUEST SYNCML ... Contacts loaded (#(GetTickCount() - a_tc_lookup)#)" type="information" log="application" file="ib_syncml">
			
<cfset q_select_contacts = stReturn_contacts.q_select_contacts>

<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_addressbook"
	defaultvalue1 = "category"
	savesettings = true
	userid = #request.a_struct_security_context.myuserid#
	setcallervariable1 = "a_str_restriction_addressbook">
	
<cfswitch expression="#a_str_restriction_addressbook#">
	<cfcase value="all">
		<!--- do no modifications ... --->
	
	</cfcase>
	<cfcase value="private">
		<!--- private items ... --->
		<cfset sEntrykeys_to_load = 'dummyentry'>
		
		<cfloop query="q_select_contacts">
			<cfif CompareNoCase(request.a_struct_security_context.myuserkey, q_select_contacts.userkey) IS 0>
				<cfset sEntrykeys_to_load = ListAppend(sEntrykeys_to_load, q_select_contacts.entrykey)>
			</cfif>
		</cfloop>
		
		<cfquery name="q_select_contacts" dbtype="query">
		SELECT
			*
		FROM
			q_select_contacts
		WHERE
			entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys_to_load#" list="yes">)
		;
		</cfquery>
		
	</cfcase>
	<cfdefaultcase>
		<!--- default: only elements with category "mobile" --->
		
		<cfset sEntrykeys_to_load = 'dummyentry'>
		
		<cfloop query="q_select_contacts">
		
			<cfset a_str_categories_contact = ReplaceNoCase(q_select_contacts.categories, ', ', ',', 'ALL')>
			<cfset a_str_categories_contact = ReplaceNoCase(a_str_categories_contact, '; ', ';', 'ALL')>
					
			<cfif ListFindNoCase(a_str_categories_contact, 'mobile', ';,') GT 0>
				<cfset sEntrykeys_to_load = ListAppend(sEntrykeys_to_load, q_select_contacts.entrykey)>
			</cfif>
		</cfloop>
		
		<cfquery name="q_select_contacts" dbtype="query">
		SELECT
			*
		FROM
			q_select_contacts
		WHERE
			entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys_to_load#" list="yes">)
		;
		</cfquery>
	
	</cfdefaultcase>
</cfswitch>

<cflog text="SEARCH REQUEST SYNCML ... Checked restrictions (#(GetTickCount() - a_tc_lookup)#)" type="information" log="application" file="ib_syncml">

<!--- remove ignore items ... --->
<cfif q_select_ignore_items.recordcount GT 0>

	<cfquery name="q_select_contacts" dbtype="query">
	SELECT
		*
	FROM
		q_select_contacts
	WHERE
		NOT entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_ignore_items.entrykey)#" list="yes">)
	;
	</cfquery>
</cfif>

<cflog text="SEARCH REQUEST SYNCML ... Removed ignore items (#(GetTickCount() - a_tc_lookup)#)" type="information" log="application" file="ib_syncml">

<cfif StructCount(a_struct_internal_filter) GT 0>
	<!--- ... --->
	<cflog text="SEARCH REQUEST SYNCML ... internal filter applies (#(GetTickCount() - a_tc_lookup)#)" type="information" log="application" file="ib_syncml">

	<cflog text="recordcount until now: #q_select_contacts.recordcount# (a_struct_filter: #StructKeyList(a_struct_filter)#" type="information" log="application" file="ib_syncml">
	
	<cfquery name="q_select_contacts" dbtype="query">
	SELECT
		*
	FROM
		q_select_contacts
	WHERE
		(1 = 1)

	<!--- loop through the provided search parameters ... --->	
	<cfloop list="#StructKeyList(a_struct_internal_filter)#" index="a_str_item">
	
		<cfif Len(a_struct_internal_filter[a_str_item]) GT 0>
		
			<cflog text="internal filter applies ... parameter #a_str_item#: #a_struct_internal_filter[a_str_item]#" type="information" log="application" file="ib_syncml">
		
			<cfswitch expression="#a_str_item#">
				<cfcase value="firstname">
					AND (firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_internal_filter[a_str_item]#">)
				</cfcase>
				<cfcase value="surname">
					AND (surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_internal_filter[a_str_item]#">)
				</cfcase>
				<cfcase value="email_prim">
					AND (email_prim = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_internal_filter[a_str_item]#">)
				</cfcase>
			</cfswitch>
		
		</cfif>

	</cfloop>
	;
	</cfquery>
	
	<cflog text="internal filter applies ... q_select_contacts.recordcount: #q_select_contacts.recordcount#" type="information" log="application" file="ib_syncml">
	<cflog text="SEARCH REQUEST SYNCML ... internal filter done (#(GetTickCount() - a_tc_lookup)#)" type="information" log="application" file="ib_syncml">

</cfif>

<?xml version="1.0" ?> 
<a:multistatus xmlns:a="DAV:" xmlns="<cfoutput>#XMLFormat(request.a_struct_action.path_info)#</cfoutput>">
	<cfif q_select_contacts.recordcount EQ 0>
		<cfif a_bol_select_by_id>
			<cfheader statuscode="404">
			<cfset request.a_struct_response_headers.statuscode = 404>
		</cfif>
	<cfelse>
		<cfoutput query="q_select_contacts">
		<a:response> 
		<!--- changed --->
			<a:href>#xmlformat('http://' & cgi.SERVER_NAME & request.a_struct_action.path_info & q_select_contacts.entrykey)#</a:href>
			<a:propstat>
				<a:status>HTTP/1.1 200 OK</a:status>
				<a:prop>
					<repluid>rid:#q_select_contacts.entrykey#</repluid>
					<isfolder>0</isfolder>
					<getlastmodified>#DateFormat(q_select_contacts.dt_lastmodified, "yyyy-mm-dd")# #TimeFormat(q_select_contacts.dt_lastmodified, "HH:mm:ss")#</getlastmodified>
				<cfif a_bol_diff_select>
					<creationdate>#DateFormat(q_select_contacts.dt_created, "yyyy-mm-dd")# #TimeFormat(q_select_contacts.dt_created, "HH:mm:ss")#</creationdate>
					<href>#q_select_contacts.entrykey#</href>
				<cfelse>
					<lastname>#XMLFormat(q_select_contacts.surname)#</lastname>
					<sn>#XMLFormat(q_select_contacts.surname)#</sn>
					<givenname>#XMLFormat(q_select_contacts.firstname)#</givenname>
					<!---<givenname>#XMLFormat(trim(q_select_contacts.surname &' ' & q_select_contacts.firstname))#</givenname>--->
					<middlename/>
					<title>#XMLFormat(q_select_contacts.title)#</title>
					
					<!---<subject>#XMLFormat(trim(q_select_contacts.surname &', ' & q_select_contacts.firstname))#</subject>--->
					<fileas>#XMLFormat(trim(q_select_contacts.surname &', ' & q_select_contacts.firstname))#</fileas>
					<displayname>#XMLFormat(trim(q_select_contacts.surname &', ' & q_select_contacts.firstname))#</displayname>
										
					<email1>#XMLFormat(q_select_contacts.email_prim)#</email1>
					<email2>#XMLFormat(q_select_contacts.email_adr)#</email2>
					<email3/>
					
					<organization>#XMLFormat(q_select_contacts.company)#</organization>
					<department>#XMLFormat(q_select_contacts.department)#</department>
					<profession>#XMLFormat(q_select_contacts.aposition)#</profession>
					<street>#XMLFormat(q_select_contacts.b_street)#</street>
					<city>#XMLFormat(q_select_contacts.b_city)#</city>
					<state/>
					<postalcode>#XMLFormat(q_select_contacts.b_zipcode)#</postalcode>
					<country>#XMLFormat(q_select_contacts.b_country)#</country>
					<telephonenumber>#XMLFormat(q_select_contacts.b_telephone)#</telephonenumber>
					<telephonenumber2/>
					<facsimiletelephonenumber>#XMLFormat(q_select_contacts.b_fax)#</facsimiletelephonenumber>
					<mobile>#XMLFormat(q_select_contacts.b_mobile)#</mobile>
					<businesshomepage>#XMLFormat(q_select_contacts.b_url)#</businesshomepage>
					
					<homestreet>#XMLFormat(q_select_contacts.p_street)#</homestreet>
					<homecity>#XMLFormat(q_select_contacts.p_city)#</homecity>
					<homestate/>
					<homepostalcode>#XMLFormat(q_select_contacts.p_zipcode)#</homepostalcode>
					<homecountry>#XMLFormat(q_select_contacts.p_country)#</homecountry>
					<homephone>#XMLFormat(q_select_contacts.p_telephone)#</homephone>
					<homephone2>#XMLFormat(q_select_contacts.p_mobile)#</homephone2>
					<homefax>#XMLFormat(q_select_contacts.p_fax)#</homefax>
					
					<otherstreet/>
					<othercity/>
					<otherstate/>
					<otherpostalcode/>
					<othercountry/>
					<othertelephone/>
					<otherfax/>
					<othermobile/>
					
					<secretaryphone/>
					<callbackphone/>
					<organizationmainphone/>
					<internationalisdnnumber/>
					<pager/>
					<roomnumber/>
					<nickname/>
					<spousecn/>
					<manager/>
					<secretarycn/>
					<fburl/>			
				</cfif>  
				</a:prop>
			</a:propstat>
		</a:response>
		</cfoutput>
	</cfif>
</a:multistatus>