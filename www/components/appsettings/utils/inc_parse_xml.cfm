<!--- //

	Module:        Appsettings
	Description:   Parse possible actions ...
	

// --->

<cfset a_xml_obj = XmlParse(arguments.xmldata)>

<!--- loop and parse ... --->
<cfset a_xml_root = a_xml_obj.xmlroot>

<cfset a_struct_service = StructNew()>

<cfset a_struct_service.servicekey = a_xml_root.servicekey.xmltext>
<cfset a_struct_service.basedirectory = a_xml_root.basedirectory.xmltext>

<!--- check if the last char is a slash --->
<cfif Right(a_struct_service.basedirectory, 1) NEQ request.a_str_dir_separator>
	<cfset a_struct_service.basedirectory = a_struct_service.basedirectory & request.a_str_dir_separator>
</cfif>

<!--- get the default action ... --->
<cfset a_struct_service.defaultaction = a_xml_root.defaultaction.xmltext>
<cfset a_str_default_action = a_xml_root.defaultaction.xmltext>
<cfset a_struct_service.frontend = a_xml_root.frontend.xmltext>

<cfset a_struct_service.headerinclude = ''>

<cfif StructKeyExists(a_xml_root, 'headerinclude')>
	<cfset a_struct_service.headerinclude = a_xml_root.headerinclude.xmltext>
</cfif>

<cfset a_struct_service.leftinclude = ''>

<cfif StructKeyExists(a_xml_root, 'leftinclude')>
	<cfset a_struct_service.leftinclude = a_xml_root.leftinclude.xmltext>
</cfif>

<cfset a_struct_service.basehref = ''>

<cfif StructKeyExists(a_xml_root, 'basehref')>
	<cfset a_struct_service.basehref = a_xml_root.basehref.xmltext>
</cfif>


<!--- loop through actions --->
<cfset a_node_actions = a_xml_root.actions>

<cfloop from="1" to="#ArrayLen(a_node_actions.xmlchildren)#" index="ii">
	<cfset a_node_action = a_node_actions.xmlchildren[ii]>
	
	<cfset a_str_action = a_node_action.name.xmltext>
	
	<cfset a_struct_service.actions[a_str_action] = StructNew()>
	
	<!--- template --->
	<cfset a_struct_service.actions[a_str_action].template = a_node_action.template.xmltext>
	
	<!--- second template to include? --->
	<cfset a_struct_service.actions[a_str_action].template2 = ''>	
	<cfif StructKeyExists(a_node_action, 'template2')>
		<cfset a_struct_service.actions[a_str_action].template2 = a_node_action.template2.xmltext>
	</cfif>		
	
	<!--- title --->
	<cfset a_struct_service.actions[a_str_action].title = ''>
	<cfif StructKeyExists(a_node_action, 'title')>
		<cfset a_struct_service.actions[a_str_action].title = a_node_action.title.xmltext>
	</cfif>	
	
	<!--- template type ... default, inpage, action, popup? --->
	<cfset a_struct_service.actions[a_str_action].type = 'default'>

	<cfif StructKeyExists(a_node_action, 'type')>
		<cfset a_struct_service.actions[a_str_action].type = a_node_action.type.xmltext>
	</cfif>	
	
	<!--- allowed methods ... --->
	<cfif StructKeyExists(a_node_action, 'allowedmethods')>
		<cfset a_struct_service.actions[a_str_action].allowedmethods = a_node_action.allowedmethods.xmltext>
	</cfif>			
		
	<!--- check frameset? --->
	<cfset a_struct_service.actions[a_str_action].checkframeset = 0>
	<cfif StructKeyExists(a_node_action, 'checkframeset') AND a_node_action.checkframeset.xmltext IS 1>
		<cfset a_struct_service.actions[a_str_action].checkframeset = 1>
	</cfif>
	
	<!--- call the setService page --->
	<cfset a_struct_service.actions[a_str_action].setservice = 0>
	<cfif StructKeyExists(a_node_action, 'setservice') AND a_node_action.setservice.xmltext IS 1>
		<cfset a_struct_service.actions[a_str_action].setservice = 1>
	</cfif>	
	
	<!--- default page? --->
	<cfset a_struct_service.actions[a_str_action].default = 0>

	<cfif CompareNoCase(a_str_default_action, a_str_action) IS 0>
		<cfset a_struct_service.actions[a_str_action].default = 1>
	</cfif>		
	
	<!--- attributes? --->
	<cfset a_struct_service.actions[a_str_action].attributes = ''>	
	<cfif StructKeyExists(a_node_action, 'attributes')>
		<cfset a_struct_service.actions[a_str_action].attributes = a_node_action.attributes.xmltext>
	</cfif>	
	
	<!--- base target ---->
	<cfset a_struct_service.actions[a_str_action].basetarget = ''>
	<cfif StructKeyExists(a_node_action, 'basetarget')>
		<cfset a_struct_service.actions[a_str_action].basetarget = a_node_action.basetarget.xmltext>
	</cfif>
	
	<!--- in an own directory? --->
	<cfset a_struct_service.actions[a_str_action].directory = ''>

	<cfif StructKeyExists(a_node_action, 'directory')>
		<cfset a_struct_service.actions[a_str_action].directory = a_node_action.directory.xmltext>
	</cfif>	
	
	<!--- are there default parameters? (NEW VERSION) --->
	<cfset a_struct_service.actions[a_str_action].parameters = ArrayNew(1)>	
	
	<cfif StructKeyExists(a_node_action, 'parameters')>
	
		<cfloop from="1" to="#ArrayLen(a_node_action.parameters.xmlchildren)#" index="a_int_params">
			<cfset a_node_param = a_node_action.parameters.xmlchildren[a_int_params]>
			
			<!--- check if at least name and scope exist and are not empty ... --->
			<cfif StructKeyExists(a_node_param, 'scope') AND
				  StructKeyExists(a_node_param, 'name') AND
				  (Len(a_node_param.scope.xmltext) GT 0) AND
				  (Len(a_node_param.name.xmltext) GT 0)>
			
					<!--- scope --->
					<cfset a_str_param_scope = a_node_param.scope.xmltext>
					
					<!--- name --->
					<cfset a_str_param_name = a_node_param.name.xmltext>
					
					<!--- type, default = string --->
					<cfif StructKeyExists(a_node_param, 'type')>
						<cfset a_str_param_type = a_node_param.type.xmltext>
					<cfelse>
						<cfset a_str_param_type = 'string'>
					</cfif>						
					
					<!--- required, default = 0 (false) --->
					<cfif StructKeyExists(a_node_param, 'required')>
						<cfset a_str_param_required = a_node_param.required.xmltext>
					<cfelse>
						<cfset a_str_param_required = 0>
					</cfif>			
					
					<!--- default, default = empty string... --->
					<cfif StructKeyExists(a_node_param, 'default')>
						<cfset a_str_param_default = a_node_param.default.xmltext>
					<cfelse>
						<cfset a_str_param_default = ''>
					</cfif>
					
					<!--- add to xml structure --->
					<cfset a_int_param_next_index = ArrayLen(a_struct_service.actions[a_str_action].parameters) + 1>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index] = StructNew()>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index].scope = a_str_param_scope>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index].name = a_str_param_name>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index].type = a_str_param_type>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index].default = a_str_param_default>
					<cfset a_struct_service.actions[a_str_action].parameters[a_int_param_next_index].required = a_str_param_required>
			
			</cfif>
			
		</cfloop>
	</cfif>	
	
</cfloop>

