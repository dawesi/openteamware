<cfset a_struct_load_contacts_filter = StructNew()>
<cfset a_struct_load_contacts_filter.entrykeys = 'doesnotexist'>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_load_contacts">
	<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
	<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">	
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="filter" value="#a_struct_load_contacts_filter#">
</cfinvoke>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="stReturn_load_contacts" type="html">
<cfdump var="#stReturn_load_contacts#">
</cfmail>--->

<cfset q_select_contacts = stReturn_load_contacts.q_select_contacts>

<cfset q_select_cols = QueryNew('name,type,description,defaultfield', 'VarChar,VarChar,VarChar,Integer')>

<cfloop list="#q_select_contacts.columnlist#" index="a_str_col">
	<cfset metadata = q_select_contacts.getMetaData()>
	<cfset tmp = metadata.getColumnType(q_select_contacts.findColumn(a_str_col))>
	
	<cfset a_str_col_name = lcase(a_str_col)>
	<cfset a_bol_default_field = 1>
	
	<cfif StructKeyExists(stReturn_load_contacts, 'q_select_table_fields') AND FindNoCase('db_', a_str_col_name) GT 0>
	
		<cfquery name="q_select_friendly_fieldname" dbtype="query">
		SELECT
			showname
		FROM
			stReturn_load_contacts.q_select_table_fields
		WHERE
			UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(ReplaceNoCase(a_str_col_name, 'db_', '', 'ONE'))#">
		;
		</cfquery>
		
		<cfif q_select_friendly_fieldname.recordcount IS 1>
			<cfset a_str_col_name = q_select_friendly_fieldname.showname>
			
			<cfset a_bol_default_field = 0>
		</cfif>		
	
	</cfif>
	
	<cfset tmp = QueryAddRow(q_select_cols, 1)>
	<cfset tmp = QuerySetCell(q_select_cols, 'name', a_str_col_name, q_select_cols.recordcount)>	
	<cfset tmp = QuerySetCell(q_select_cols, 'type', lcase(q_select_contacts.getColumnTypeName(metadata.getColumnType(q_select_contacts.findColumn(a_str_col)))), q_select_cols.recordcount)>
	<cfset tmp = QuerySetCell(q_select_cols, 'description', '', q_select_cols.recordcount)>
	<cfset tmp = QuerySetCell(q_select_cols, 'defaultfield', a_bol_default_field, q_select_cols.recordcount)>

</cfloop>

<cfset stReturn.data = q_select_cols>