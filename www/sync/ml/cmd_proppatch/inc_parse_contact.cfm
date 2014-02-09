<!--- add data now ... --->
<cfset a_struct_data = StructNew()>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:fileas', 'SaveAs')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:Subject', 'Subject')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:givenName', 'firstname')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:sn', 'surname')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:o', 'company')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:department', 'department')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:profession', 'position')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:personaltitle', 'title')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:title', 'position')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:email1', 'email_prim')>

<cfif StructKeyExists(a_struct_data, 'email_prim')>
	<cfset a_struct_data.email_prim = ExtractEmailAdr(a_struct_data.email_prim)>
	
	<cfif Len(a_struct_data.email_prim) IS 0>
		<cfset tmp = StructDelete(a_struct_data, 'email_prim')>
	</cfif>
</cfif>

<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:email2', 'email_adr')>

<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:street', 'b_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:telephoneNumber', 'b_telephone')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:mobile', 'b_mobile')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:businesshomepage', 'b_url')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:postalcode', 'b_zipcode')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:postofficebox', 'b_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:facsimiletelephonenumber', 'b_fax')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:st', 'b_country')>

<!--- first possibilty ... "home" data --->
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homePhone', 'p_telephone')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homecity', 'p_city')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homefax', 'p_fax')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homepostalcode', 'p_zipcode')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homestreet', 'p_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homecountry', 'p_country')>

<!--- home data --->
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:homePhone', 'p_telephone')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:othercity', 'p_city')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:otherfax', 'p_fax')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:otherpostalcode', 'p_zipcode')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:otherstreet', 'p_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:othercountry', 'p_country')>

<!--- birthday --->
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:bday', 'birthday')>
<cfif StructKeyExists(a_struct_data, 'birthday')>
	
	<cftry>
		<cfset a_struct_data.birthday = GetWebDavDate(a_struct_data.birthday)>
		
		<cfif isDate(a_struct_data.birthday)>
			<cfset a_struct_data.birthday = ParseDateTime(a_struct_data.birthday)>
		</cfif>

	<cfcatch type="any">
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="parse birthday exception" type="html">
			<cfdump var="#cfcatch#">
		</cfmail>
	</cfcatch>
	</cftry>
</cfif>


<cfset a_struct_data.notice = ''>
<cfset a_struct_data.archiveentry = 0>
<cfset a_struct_data.contacttype = 0>
<cfset a_struct_data.parentcontactkey = ''>

<cfset request.a_struct_contact = a_struct_data>


<!---<cfscript>
	elements = XmlSearch(request.a_struct_action.a_xml_obj, "//D:propertyupdate/D:set/D:prop");
	
</cfscript>--->

<!---<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:street', 'b_city')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:street', 'b_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:street', 'b_street')>
<cfset a_struct_data = CheckExchangeElementAndAddToStructure(a_struct_data, 'HM:street', 'b_street')>

		request.a_struct_contact.b_street = propElems[17].XmlText; //HM:street
		request.a_struct_contact.b_city = propElems[18].XmlText; //HM:l
		request.a_struct_contact.b_zipcode = propElems[21].XmlText; //HM:co
		request.a_struct_contact.b_country = propElems[20].XmlText; //HM:postalcode
		request.a_struct_contact.b_telephone = propElems[27].XmlText; //HM:telephoneNumber
		request.a_struct_contact.b_fax = propElems[32].XmlText; //HM:facsimiletelephonenumber
		request.a_struct_contact.b_mobile = propElems[29].XmlText; //HM:mobile
		request.a_struct_contact.b_url = propElems[42].XmlText; //HM:businesshomepage
		request.a_struct_contact.p_street = propElems[12].XmlText; //HM:homeStreet
		request.a_struct_contact.p_city = propElems[13].XmlText; //HM:homeCity
		request.a_struct_contact.p_zipcode = propElems[15].XmlText; //HM:homePostalCode
		request.a_struct_contact.p_country = propElems[16].XmlText; //HM:homeCountry
		request.a_struct_contact.p_telephone = propElems[28].XmlText; //HM:homePhone
		request.a_struct_contact.p_fax = propElems[37].XmlText; //HM:homefax
		request.a_struct_contact.p_mobile = propElems[36].XmlText; //HM:homephone2
		request.a_struct_contact.p_url = '';
		request.a_struct_contact.notice = '';
		request.a_struct_contact.archiveentry = 0;
		request.a_struct_contact.contacttype = 0;
--->

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="request.a_struct_action (inc_parse_contact.cfm)" type="html">
<html>
<body>
<cfdump var="#a_struct_data#" label="a_struct_data">
<br><br>
<!---<cfdump var="#elements#" label="elements">--->
<cfdump var="#request.a_struct_action#">
<cfdump var="#cgi#">
</body>
</html>
</cfmail>--->

	<!---
	
	old
	<cfscript>
		// old
		//elements = XmlSearch(request.a_struct_action.a_xml_obj, "//D:prop");
		
		elements = XmlSearch(request.a_struct_action.a_xml_obj, "//D:propertyupdate");
		
		

		propElems = elements[1].XmlChildren;
		
		request.a_struct_contact = StructNew();
		request.a_struct_contact.firstname = propElems[7].XmlText; //HM:givenName
		request.a_struct_contact.surname = propElems[8].XmlText; //HM:sn
		request.a_struct_contact.company = propElems[11].XmlText; //HM:o
		request.a_struct_contact.department = propElems[43].XmlText; //HM:department
		request.a_struct_contact.position = propElems[45].XmlText; //HM:profession
		request.a_struct_contact.title = propElems[10].XmlText; //HM:title
		request.a_struct_contact.sex = -1;

		a_str_tmp = Trim(propElems[51].XmlText); //HM:email1
		if (Len(a_str_tmp) GT 0) {
			a_int_tmp = Find('<', a_str_tmp);
			a_str_tmp = Mid(a_str_tmp, a_int_tmp + 1, Find('>', a_str_tmp) - a_int_tmp - 1);
		}
		request.a_struct_contact.email_prim = a_str_tmp;
		request.a_struct_contact.email_adr = propElems[52].XmlText; //HM:email2
		request.a_struct_contact.birthday = '';
		request.a_struct_contact.categories = '';
		request.a_struct_contact.b_street = propElems[17].XmlText; //HM:street
		request.a_struct_contact.b_city = propElems[18].XmlText; //HM:l
		request.a_struct_contact.b_zipcode = propElems[21].XmlText; //HM:co
		request.a_struct_contact.b_country = propElems[20].XmlText; //HM:postalcode
		request.a_struct_contact.b_telephone = propElems[27].XmlText; //HM:telephoneNumber
		request.a_struct_contact.b_fax = propElems[32].XmlText; //HM:facsimiletelephonenumber
		request.a_struct_contact.b_mobile = propElems[29].XmlText; //HM:mobile
		request.a_struct_contact.b_url = propElems[42].XmlText; //HM:businesshomepage
		request.a_struct_contact.p_street = propElems[12].XmlText; //HM:homeStreet
		request.a_struct_contact.p_city = propElems[13].XmlText; //HM:homeCity
		request.a_struct_contact.p_zipcode = propElems[15].XmlText; //HM:homePostalCode
		request.a_struct_contact.p_country = propElems[16].XmlText; //HM:homeCountry
		request.a_struct_contact.p_telephone = propElems[28].XmlText; //HM:homePhone
		request.a_struct_contact.p_fax = propElems[37].XmlText; //HM:homefax
		request.a_struct_contact.p_mobile = propElems[36].XmlText; //HM:homephone2
		request.a_struct_contact.p_url = '';
		request.a_struct_contact.notice = '';
		request.a_struct_contact.archiveentry = 0;
		request.a_struct_contact.contacttype = 0;
		request.a_struct_contact.parentcontactkey = '';
	</cfscript>
	
	
	--->

<!---
<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="request.a_struct_contact" type="html">
<cfdump var="#request.a_struct_contact#">
</cfmail>--->