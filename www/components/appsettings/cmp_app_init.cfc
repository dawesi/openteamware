<!--- //

	Component:	cmp_app_init
	Description:Create cached components
	
// --->

<cfcomponent output='false'>
	
	<cffunction access="public" name="InitApplicationComponents" output="false" returntype="boolean">
		
		<cfset var sTransferConfigPath = '/configuration/transfer/' />
		<cfset var tmp = false />
		
		<cfset request.bAppInit_running = true>
		
		<cflock scope="Application" timeout="90" type="exclusive">
		
			<cfset applications.components = StructNew() />
		
			<!--- important: load these components first ... --->
			<cfset application.components.cmp_datatypeconvert = CreateObject('component', request.a_str_component_datatypeconvert) />
			
			<cfset application.components.cmp_tools = CreateObject('component', request.a_str_component_tools) />
			
			<cfset application.components.cmp_render = CreateObject("component", request.a_str_component_render) />
			
			<cfset application.components.cmp_content = CreateObject("component", request.a_str_component_content) />
				
			<cfset application.components.cmp_security = CreateObject("component", request.a_str_component_security) />
			
			<cfset application.components.cmp_history = CreateObject("component", "/components/tools/cmp_history") />
			
			<cfset application.components.cmp_followups = CreateObject("component", request.a_str_component_followups) />
			
			<cfset application.components.cmp_load_user_data = CreateObject("component", "/components/management/users/cmp_load_userdata") />
			
			<cfset application.components.cmp_fckeditor = CreateObject('component', request.a_str_component_fckeditor) />
			
			<cfset application.components.cmp_session = CreateObject('component', request.a_str_component_session) />
			
			<cfset application.components.cmp_licence = CreateObject('component', request.a_str_component_licence) />
			
			<cfset application.components.cmp_email = CreateObject('component', request.a_str_component_email) />
			
			<cfset application.components.cmp_email_tools = CreateObject('component', '/components/email/cmp_tools') />
									
			<cfset application.components.cmp_email_accounts = CreateObject('component', request.a_str_component_email_accounts) />
			
			<cfset application.components.cmp_email_mailconnector = CreateObject('component', request.a_str_component_mailconnector) />
			
			<cfset application.components.cmp_email_message = CreateObject('component', request.a_str_component_email_message) />
			
			<cfset application.components.cmp_events = CreateObject('component', request.a_str_component_events) />
			
			<cfset application.components.cmp_customize = CreateObject('component', request.a_str_component_customize) />
			
			<cfset application.components.cmp_forms = CreateObject('component', request.a_str_component_forms) />
			
			<cfset application.components.cmp_customer = CreateObject('component', request.a_str_component_customer) />
			
			<cfset application.components.cmp_user = CreateObject('component', request.a_str_component_users) />
			
			<cfset application.components.cmp_calendar = CreateObject('component', request.a_str_component_calendar) />
			
			<cfset application.components.cmp_person = CreateObject('component', request.a_str_component_person) />
			
			<cfset application.components.cmp_cache = CreateObject('component', request.a_str_component_cache) />
			
			<cfset application.components.cmp_addressbook = CreateObject('component', request.a_str_component_addressbook) />
			
			<cfset application.components.cmp_crmsales = CreateObject('component', request.a_str_component_crm_sales) />
			
			<cfset application.components.cmp_log = CreateObject('component', request.a_str_component_logs) />
			
			<cfset application.components.cmp_assigned_items = CreateObject('component', request.a_str_component_assigned_items) />
			
			<cfset application.components.cmp_tasks = CreateObject('component', request.a_str_component_tasks) />
			
			<cfset application.components.cmp_workgroups = CreateObject('component', request.a_str_component_workgroups) />
			
			<cfset application.components.cmp_lang = CreateObject('component', request.a_str_component_lang) />
			
			<cfset application.components.cmp_locks = CreateObject('component', request.a_str_component_locks) />

			<cfset application.components.cmp_resources = CreateObject('component', request.a_str_component_resources) />
			
			<cfset application.components.cmp_storage = CreateObject('component', request.a_str_component_storage) />
			
			<cfset application.components.cmp_import = CreateObject('component', request.a_str_component_import) />

			<cfset application.components.cmp_products = CreateObject('component', request.a_str_component_products) />

			<cfset application.components.cmp_projects = CreateObject('component', request.a_str_component_project) />			
			
			<cfset application.components.cmp_sql = CreateObject('component', request.a_str_component_sql) />	
			
			<cfset application.components.cmp_newsletter = CreateObject('component', request.a_str_component_newsletter) />
			
			<cfset application.components.cmp_forum = CreateObject('component', request.a_str_component_forum) />
			
			<cfset application.components.cmp_crm_reports = CreateObject('component', '/components/crmsales/crm_reports') />		
									
		</cflock>
		
		<cfset tmp = StructDelete(request, 'bAppInit_running') />
		
		<cfreturn true />		
	</cffunction>
	
</cfcomponent>