<!--- //

	Component:	Forms
	Description:
	
	check if a certain callback function exists
	... load data from the given source if needed
	
	To-Do: Create a XML/database version of this function ...
	
	<functions>
		<name></name>
		<component></component>
		<arguments>
			<name></name>
			<value></value>
			<required></required>
		</arguments>
	</functions>
	

// --->

<cfswitch expression="#arguments.function_name#">

	<cfcase value="GetProjectsOfContact">
		<!--- get the sales projects attached to a certain contact --->
		
		
		<cfset a_struct_filter_projects.active_only = true />
		<cfset a_struct_filter_projects.contactkeys = GetCallBackFunctionParameterByName('contactkey') />
		
		<cfset q_select_projects = application.components.cmp_projects.GetAllProjects(securitycontext = arguments.securitycontext,
													usersettings = arguments.usersettings,
													filter = a_struct_filter_projects).q_select_projects />
		
		<cfif q_select_projects.recordcount GT 0>
		
			<!--- add now to options field ... --->
			<cfset stReturn.result = true>
			<cfset stReturn.options = AddOptionsElementFromQuery(stReturn.options, q_select_projects, 'title', 'entrykey')>

		</cfif>
		
	</cfcase>
	
	<cfcase value="GetAllMailFolders">
		<!--- return all mail folders ... --->
		<cfset a_struct_folders = application.components.cmp_email.loadfolders(securitycontext = arguments.securitycontext,
											usersettings = arguments.usersettings,
											accessdata = arguments.securitycontext.a_struct_imap_access_data) />
		<!--- add folders ... --->
		<cfset stReturn.result = true>		
		<cfset stReturn.options = AddOptionsElementFromQuery(stReturn.options, a_struct_folders.query, 'foldername', 'fullfoldername')>

	</cfcase>

</cfswitch>

