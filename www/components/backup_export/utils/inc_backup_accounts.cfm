<!--- //

	Module:		
	Action:		
	Description:Load all organisations of this user	
	

// --->

<cfsetting requesttimeout="30000">
	
<!--- load only private items --->
<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.workgroupkey = 'private' />

<!--- load max. 99999 records ... --->
<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 99999 />
	
<!--- filterdatatypes = 1 --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_accounts">
	<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="filterdatatypes" value="1">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<!--- remove unwanted columns (NEW: entrykey and userkey will be saved!!) --->
<cfset q_select_accounts = queryRemoveColumns(thequery = stReturn_accounts.q_select_contacts, columnsToRemove = 'workgroupkeys') />

<cfset LogMessage('contacts: ' & q_select_accounts.recordcount) />

<!--- generate CSV --->
<cfset a_csv_accounts = QueryToCSV2(q_select_accounts) />

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'accounts' />

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_backup_dir#/accounts.csv" output="#a_csv_accounts#">
