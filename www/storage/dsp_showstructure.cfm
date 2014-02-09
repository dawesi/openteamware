

<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetDirectoryStructure"   
		returnVariable = "a_struct_structure"   
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		 >
</cfinvoke>

<cfdump var="#a_struct_structure#">

