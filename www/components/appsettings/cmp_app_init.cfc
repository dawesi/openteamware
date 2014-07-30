<!--- //

	Component:	cmp_app_init
	Description:Create cached components

// --->

<cfcomponent output='false'>

	<cffunction access="public" name="InitApplicationComponents" output="false" returntype="boolean">

		<cfset request.bAppInit_running = true>

		<cflock scope="Application" timeout="90" type="exclusive">

			<cfset applications.components = StructNew() />

			<cfset application.components.cmp_log = CreateObject('component', request.a_str_component_logs) />

			<!--- important: load these components first ... --->
			<cfset application.components.cmp_datatypeconvert = CreateObject('component', request.a_str_component_datatypeconvert) />

			<cfset application.components.cmp_tools = CreateObject('component', request.a_str_component_tools) />

			<cfset application.components.cmp_render = CreateObject("component", request.a_str_component_render) />

			<cfset application.components.cmp_content = CreateObject("component", request.a_str_component_content) />

			<cfset application.components.cmp_security = CreateObject("component", request.a_str_component_security) />

			<cfset application.components.cmp_followups = CreateObject("component", request.a_str_component_followups) />

			<cfset application.components.cmp_calendar = createObject( '/components/calendar/cmp_calendar' ) />

			<cfset application.components.cmp_customer = createObject( '/components/management/customers/cmp_customer') />

			<cfset application.components.cmp_load_user_data = CreateObject("component", "/components/management/users/cmp_load_userdata") />

			<cfset application.components.cmp_session = CreateObject('component', request.a_str_component_session) />

			<cfset application.components.cmp_events = CreateObject('component', request.a_str_component_events) />

			<cfset application.components.cmp_customize = CreateObject('component', request.a_str_component_customize) />

			<cfset application.components.cmp_forms = CreateObject('component', request.a_str_component_forms) />

			<cfset application.components.cmp_user = CreateObject('component', request.a_str_component_users) />

			<cfset application.components.cmp_person = CreateObject('component', request.a_str_component_person) />

			<cfset application.components.cmp_cache = CreateObject('component', request.a_str_component_cache) />

			<cfset application.components.cmp_addressbook = CreateObject('component', request.a_str_component_addressbook) />

			<cfset application.components.cmp_crmsales = CreateObject('component', request.a_str_component_crm_sales) />

			<cfset application.components.cmp_assigned_items = CreateObject('component', request.a_str_component_assigned_items) />

			<cfset application.components.cmp_tasks = CreateObject('component', request.a_str_component_tasks) />

			<cfset application.components.cmp_workgroups = CreateObject('component', request.a_str_component_workgroups) />

			<cfset application.components.cmp_lang = CreateObject('component', request.a_str_component_lang) />

			<cfset application.components.cmp_locks = CreateObject('component', request.a_str_component_locks) />

			<cfset application.components.cmp_resources = CreateObject('component', request.a_str_component_resources) />

			<cfset application.components.cmp_import = CreateObject('component', request.a_str_component_import) />

			<cfset application.components.cmp_products = CreateObject('component', request.a_str_component_products) />

			<cfset application.components.cmp_projects = CreateObject('component', request.a_str_component_project) />

			<cfset application.components.cmp_sql = CreateObject('component', request.a_str_component_sql) />

		</cflock>

		<cfset StructDelete(request, 'bAppInit_running') />

		<cfreturn true />
	</cffunction>

</cfcomponent>