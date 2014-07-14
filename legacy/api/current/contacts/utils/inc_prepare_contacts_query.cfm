<!--- //

	prepare contacts query
	
	if CRM is enabled, try to set correct fieldnames
	
	// --->
	

<cfif StructKeyExists(stReturn_load_contacts, 'q_select_table_fields')>

	<cfset a_str_col_list = stReturn_load_contacts.q_select_contacts.ColumnList>
	
	<cfset a_struct_cols = StructNew()>
	
	<!--- set default ... --->
	<cfloop list="#a_str_col_list#" index="a_str_item">
		<cfset a_struct_cols[a_str_item] = a_str_item>
	</cfloop>
	
	<!--- now, loop through custom table fields ... --->
	<cfloop query="stReturn_load_contacts.q_select_table_fields">
		
		<cfset a_str_tmp_fieldname = 'db_' & stReturn_load_contacts.q_select_table_fields.fieldname>
		
		<cfif StructKeyExists(a_struct_cols, a_str_tmp_fieldname)>
			<!--- set showname as new columnname ... --->
			
			<cfset a_struct_cols[a_str_tmp_fieldname] = stReturn_load_contacts.q_select_table_fields.showname>
		</cfif>
		
	</cfloop>
	
	<cfset a_str_col_list = StructKeyList(a_struct_cols)>
	
	<!--- compose SQL select statement ... --->
	<cfsavecontent variable="a_str_sql_cols">
	
		<cfloop list="#a_str_col_list#" index="a_str_item">
		
			<cfset a_col_name = a_struct_cols[a_str_item]>
			
			<cfset a_col_name = ReReplaceNoCase(a_col_name, '[^0-9,a-z,_]', '', 'ALL')>
			
			<cfif ListFindNoCase('addressbookkey', a_col_name) IS 0>
				<cfoutput>#a_str_item# AS #lcase(a_col_name)#</cfoutput>,				
			</cfif>			

		</cfloop>
	</cfsavecontent>
	
	<!--- trim statement ... --->
	<cfset a_str_sql_cols = trim(a_str_sql_cols)>
	
	<cfif Right(a_str_sql_cols, 1) IS ','>
		<cfset a_str_sql_cols = Left(a_str_sql_cols, Len(a_str_sql_cols)-1)>
	</cfif>
	
	<cflog text="selecting data ..." type="Information" log="Application" file="ib_ws">
	
	<cfquery name="stReturn_load_contacts.q_select_contacts" dbtype="query">
	SELECT
		#a_str_sql_cols#
	FROM
		stReturn_load_contacts.q_select_contacts
	;
	</cfquery>
	
	<cflog text="selecting data: done" type="Information" log="Application" file="ib_ws">
</cfif>