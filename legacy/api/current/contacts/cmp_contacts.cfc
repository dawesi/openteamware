<cfcomponent output=false>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="../../scripts/scripts_ws.cfm">
	
	<cfparam name="client.langno" type="numeric" default="0">
	
	<cffunction access="remote" name="CreateContacts" output="false" returntype="string" hint="create one or more contacts">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="The entrykey of the application">
		<cfargument name="data" type="string" required="yes" hint="xml containing the data. See documentation.">
		<cfargument name="options" type="string" required="no" default="" hint="various options in xml format">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
				
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">
	
		<cfif CheckReturnStructureForError(stReturn)>
			<cfreturn GenerateReturnXMLDocumentFromReturnStructure(stReturn)>
		</cfif>
			
		<!--- is xml? --->
		<cfif NOT CheckIfInputDataIsXML(arguments.data)>
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(20, stReturn)>
		</cfif>
		
		<!--- parse incoming XML now ... --->
		<cfset a_xml_obj = XmlParse(arguments.data)>
		
		<cfset a_arr_contacts = XmlSearch(a_xml_obj, '/contacts/contact')>
		
		<cfset stReturn.count = ArrayLen(a_arr_contacts)>
		
		<cfif ArrayLen(a_arr_contacts) IS 0>
			<!--- invalid xml document ... --->
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(601, stReturn)>
		</cfif>
		
		<cfinclude template="utils/inc_check_contacts.cfm">
		
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>
		
	</cffunction>
	
	<!--- GetContact ... dummy function for GetContacts --->
	<cffunction access="remote" name="GetContact" output="false" returntype="string" hint="return a specific contact">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of contact">
		<cfargument name="options" type="string" required="no" default="" hint="various options in xml format">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>	
		<cfset var a_str_xml_filter = ''>
						
		<!--- forward to GetContacts using a filter ... --->		
		<cfxml variable="a_str_xml_filter">
			<entrykeys><cfoutput>#xmlformat(arguments.entrykey)#</cfoutput></entrykeys>
		</cfxml>
		
		<cfreturn GetContacts(clientkey = arguments.clientkey, applicationkey = arguments.applicationkey, filter = toString(a_str_xml_filter))>
	</cffunction>
	
	<cffunction access="remote" name="GetContacts" output="false" returntype="string" hint="return all contacts">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="filter" type="string" required="no" default="" hint="various filters in xml format ...">
		<cfargument name="options" type="string" required="no" default="" hint="various options in xml format ...">
		
		<!--- filter
		
			entrykeys ...
			crmfilterkeys ...
			search ...
			
			--->
			
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
		<cfset var a_struct_load_contacts_filter = StructNew()>
		<cfset var a_struct_load_contacts_options = StructNew()>
		
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">			
		
		<cfif CheckReturnStructureForError(stReturn)>
			<cfreturn GenerateReturnXMLDocumentFromReturnStructure(stReturn)>
		</cfif>
		
		<!--- check if we've got filters ... --->
		<cfif isXml(arguments.filter)>
			<cfinclude template="utils/inc_check_filter.cfm">
		</cfif>
		
		<!--- check options ... --->
		<cfif isXml(arguments.options)>
			<cfinclude template="utils/inc_check_options.cfm">
		</cfif>		
		
		<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_load_contacts">
			<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
			<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">	
			<cfinvokeargument name="loadowndatafields" value="true">
			<cfinvokeargument name="loadfulldata" value="true">
			<cfinvokeargument name="filter" value="#a_struct_load_contacts_filter#">
			<cfinvokeargument name="loadoptions" value="#a_struct_load_contacts_options#">
		</cfinvoke>
		
		<cfinclude template="utils/inc_prepare_contacts_query.cfm">
		
		<cfset q_select_contacts = stReturn_load_contacts.q_select_contacts>
		
		<cfset stReturn.data = StructNew()>
		<cfset stReturn.data.dummy = '123'>
		<cfset stReturn.data.contacts = q_select_contacts>
				
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>
	</cffunction>
	
	<cffunction access="remote" name="UpdateContact" output="false" returntype="string" hint="update contact">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="data" type="string" required="yes" hint="xml containing the data">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of the contact">
		<cfargument name="options" type="string" required="no" default="" hint="various options in xml format">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
				
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">	
		
		<cfif CheckReturnStructureForError(stReturn)>
			<cfreturn GenerateReturnXMLDocumentFromReturnStructure(stReturn)>
		</cfif>
				
		<cfif NOT CheckIfInputDataIsXML(arguments.data)>
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(20, stReturn)>
		</cfif>
		
		<!--- ok, go and parse the data now ... --->
		<cfinclude template="utils/inc_check_update.cfm">
		
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>				
	</cffunction>
	
	<cffunction access="remote" name="DeleteContact" output="false" returntype="string" hint="delete a contact">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of the contact">
		<cfargument name="options" type="string" required="no" default="" hint="various options in xml format">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
				
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">		

		<cfif CheckReturnStructureForError(stReturn)>
			<cfreturn GenerateReturnXMLDocumentFromReturnStructure(stReturn)>
		</cfif>
		
		<!--- call delete --->
		<cfinvoke component="#application.components.cmp_addressbook#" method="DeleteContact" returnvariable="a_bol_return_delete_contact">
			<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
			<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">	
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfif NOT a_bol_return_delete_contact>
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(40, stReturn)>
		</cfif>
		
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>	
	</cffunction>

</cfcomponent>