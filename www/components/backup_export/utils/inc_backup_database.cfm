<cfsetting requesttimeout="30000">
<!--- 
<!--- create database component --->
<cfset variables.a_cmp_database = CreateObject('component', request.a_str_component_database)>

<!--- create a special backup directory for databases --->
<cfset a_str_backup_dir_database = a_str_backup_directory & request.a_str_dir_separator & 'database' & request.a_str_dir_separator>

<!--- create the database directory --->
<cfdirectory action="create" directory="#a_str_backup_dir_database#">

<!--- get databases of user --->
<cfinvoke
		component = "#variables.a_cmp_database#"   
		method = "ListDatabases"   
		returnVariable = "q_select_databases"   
		securitycontext="#variables.stSecurityContext#"
		usersettings="#variables.stUserSettings#"
		options="#StructNew()#">
</cfinvoke>		

<cfquery name="q_select_databases" dbtype="query">
SELECT
	*
FROM
	q_select_databases
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.stSecurityContext.myuserkey#">
;
</cfquery>

<cfset tmp = LogMessage('databases: ' & q_select_databases.recordcount)>

<cfloop query="q_select_databases">

	<!--- get all tables --->
	<cfinvoke
			component = "#variables.a_cmp_database#"   
			method = "ListTables"   
			returnVariable = "q_select_tables"   
			securitycontext="#variables.stSecurityContext#"
			usersettings="#variables.stUserSettings#"
			database_entrykey="#q_select_databases.entrykey#"
			options="#StructNew()#">
	</cfinvoke>
	
	<!--- return just a-z and 0-9 chars of the database name --->
	<cfset a_str_db_name = ReturnStringWithOnlyAZ09(q_select_databases.name)>
	
	<cfif Len(a_str_db_name) IS 0>
		<cfset a_str_db_name = q_select_databases.entrykey>
	</cfif>
	
	<cfset variables.a_str_current_backup_database_dir = a_str_backup_dir_database & a_str_db_name>
	
	<!--- create directory for this database --->
	<cfdirectory directory="#variables.a_str_current_backup_database_dir#" action="create">
	
	<cfset tmp = LogMessage('next database: ' & q_select_databases.name)>
	<cfset tmp = LogMessage('tables count: ' & q_select_tables.recordcount)>
	
	<cfloop query="q_select_tables">
	
		<cftry>
		
		<!--- export every single table to CSV ... --->
		<cfinvoke component="#variables.a_cmp_database#" method="ExportTable" returnvariable="stReturn_table">
			<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">
			<cfinvokeargument name="tablekey" value="#q_select_tables.entrykey#">
			<cfinvokeargument name="format" value="CSV">
		</cfinvoke>
		
		<cfset a_str_table_name = ReturnStringWithOnlyAZ09(q_select_tables.tablename)>
	
		<cfif Len(a_str_table_name) IS 0>
			<cfset a_str_table_name = q_select_tables.entrykey>
		</cfif>		
		
		<cfset a_str_tmp_filename = variables.a_str_current_backup_database_dir & request.a_str_dir_separator & a_str_table_name & '.csv'>
		
		<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_tmp_filename#" output="#stReturn_table.csv#">		
		
		<cfset tmp = LogMessage('table done: ' & q_select_tables.tablename)>
		
		<cfcatch type="any">
		<!--- if something happens during backup of a table --->
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="backup exception during backup of a table" type="html">
			entrykey: #q_select_tables.entrykey#
			<br>
			<cfdump var="#cfcatch#">
			<cfdump var="#q_select_tables#">
			<cfdump var="#variables.stSecurityContext#">
		</cfmail>
		</cfcatch>
		</cftry>
		
	</cfloop>

</cfloop> --->