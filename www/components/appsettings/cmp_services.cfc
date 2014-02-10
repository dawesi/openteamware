<!--- //

	Component:	Services
	Description:Load service settings
	
// --->

<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- return all services switches for caching ... --->

	<!--- return the structure with the action switches --->	
	<cffunction access="public" name="GetServiceActionSwitches" output="false" returntype="struct"
			hint="return actions of the given service ...">
		<cfargument name="servicekey" type="string" required="yes"
			hint="entrykey of service">
		<cfargument name="frontend" type="string" required="yes"
			hint="platform, default is www (other are pda or wap)">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_str_xml_data = ''>
		<cfset var a_str_xml_filename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'services' & ReturnDirSeparatorOfCurrentOS() & servicekey & '.xml'>

		<cfif FileExists(a_str_xml_filename)>
			<cffile action="read" charset="utf-8" file="#a_str_xml_filename#" variable="a_str_xml_data">
			<cfset stReturn =  ParseSwitchesXML(a_str_xml_data)>
		</cfif>
	
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="LoadAllServicesActionsSwitches" output="false" returntype="struct"
			hint="load and return all available action switches ...">
		<cfargument name="frontend" type="string" required="yes"
			hint="platform, currently www, pda or wap">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_str_xml_directory = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'services' & ReturnDirSeparatorOfCurrentOS()>
		<cfset var a_str_servicekey_list = '' />
		<cfset var a_str_servicekey = '' />
		<cfset var q_select_services = 0 />
		
		<cfdirectory action="list" filter="*.xml" directory="#a_str_xml_directory#" name="q_select_services">
		
		<cfset a_str_servicekey_list = ValueList(q_select_services.name)>
		<cfset a_str_servicekey_list = ReplaceNoCase(a_str_servicekey_list, '.xml', '', 'ALL')>
		
		<cfloop list="#a_str_servicekey_list#" index="a_str_servicekey">
			<cfset stReturn[a_str_servicekey] = GetServiceActionSwitches(servicekey= a_str_servicekey, frontend=arguments.frontend)>
		</cfloop>
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="LoadAvailableSecurityActionsOfServices" output="false" returntype="struct">
		<cfset var stReturn = GenerateReturnStruct()>
		<cfset var a_str_xml_file = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'xml.databases' & ReturnDirSeparatorOfCurrentOS() & 'mysecurity.avaliableactions.xml'>
		
		<cfinclude template="utils/inc_load_mysecurity_availableactions.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>
	
	<!--- parse the xml and create a structure --->
	<cffunction access="public" name="ParseSwitchesXML" output="false" returntype="struct">
		<cfargument name="xmldata" type="string" required="yes">
		
		<cfset var a_struct_service = StructNew()>
		
		<cfinclude template="utils/inc_parse_xml.cfm">
		
		<cfreturn a_struct_service>
		
	</cffunction>
	
</cfcomponent>