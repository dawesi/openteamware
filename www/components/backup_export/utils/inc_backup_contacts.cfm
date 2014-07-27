<!--- //

	Module:		
	Action:		
	Description:load all contacts of THIS user
				Load all organisations of this user	
	

// --->

<cfsetting requesttimeout="30000">
	
<!--- load only private items --->
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.workgroupkey = 'private'>

<!--- load max. 99999 records ... --->
<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_loadoptions.maxrows = 99999>
	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="filterdatatypes" value="0">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<!--- remove unwanted columns (NEW: entrykey and userkey will be saved!!) --->
<cfset q_select_contacts = queryRemoveColumns(thequery = stReturn_contacts.q_select_contacts, columnsToRemove = 'workgroupkeys')>

<cfset LogMessage('contacts: ' & q_select_contacts.recordcount)>

<!--- generate CSV --->
<cfset a_csv_addressbook = QueryToCSV2(q_select_contacts) />

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'contacts'>

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/contacts.csv" output="#a_csv_addressbook#">

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="123" mimeattach="#a_str_backup_dir#/contacts.csv" charset="utf-8">123</cfmail>--->

