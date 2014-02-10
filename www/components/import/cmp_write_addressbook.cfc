<!--- //

	Module:        Import
	Description:   Import component
	

// --->

<cfcomponent name="cmp_write_addressbook" hint="import data to address book">
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="ImportData" output="false" returntype="struct"
		hint="import data to address book">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="xmldata" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_xml_obj = arguments.xmldata />		
		<cfset var a_arr_contact = 0 />
		<cfset var a_str_item = 0 />
		<cfset var ShowCoreData = 0 />
		<cfset var a_struct_key_list= 0 />
		<cfset var stReturn_create = 0 />
		<cfset var a_arr_contacts = XmlSearch(a_xml_obj, '/contacts/contact') />
		<cfset var a_int_count = ArrayLen(a_arr_contacts) />
		<cfset var a_cmp_webservices_contacts = CreateObject('component', '/components/webservices/cmp_contacts') />

		<cfloop from="1" to="#a_int_count#" index="ii">
		
			<!--- the array holding all xml data of the contact --->
			<cfset a_arr_contact = a_arr_contacts[ii] />
			<cfset a_struct_key_list = structkeylist(a_arr_contact) />
	
			<cfset a_struct_contact = StructNew() />
	
			<cfloop list="#a_struct_key_list#" index="a_str_item">			
				<cfset a_struct_contact[a_str_item] = a_arr_contact[a_str_item].xmltext />		
			</cfloop>
	
			<!--- call insert process ... --->
			<cfinvoke component="#a_cmp_webservices_contacts#" method="CreateContactAndCRM" returnvariable="stReturn_create">
				<cfinvokeargument name="data" value="#a_struct_contact#">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			</cfinvoke>
		
		</cfloop>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>	
</cfcomponent>

<!---//
	$Log: cmp_write_addressbook.cfc,v $
	Revision 1.6  2007-10-04 16:31:17  hansjp
	var all used local variables

	Revision 1.5  2007/04/26 12:42:52  hansjp
	finished import tasks
	
	Revision 1.4  2006/12/21 09:47:45  hansjp
	included common templates + returning result in general way
		
	// --->