
<cfif Len(arguments.fieldstodisplay) GT 0>

	<cfset a_str_available_cols = arguments.query.columnlist>
	<cfset a_str_display_columns = ''>
	
	<!--- check if desired field name exists and if yes, add to list --->
	<cfloop list="#arguments.fieldstodisplay#" delimiters="," index="a_str_display_col">
		<cfif ListFindNoCase(a_str_available_cols, a_str_display_col) GT 0>
			<cfset a_str_display_columns = ListAppend(a_str_display_columns, a_str_display_col)>
		</cfif>
	</cfloop>
	
	<cfif Len(a_str_display_columns) IS 0>
		<cfset a_str_display_columns = '*'>
	</cfif>
	
	<!--- 2do: load datatypes of columns and set here again ... --->
	
	<cfquery name="arguments.query" dbtype="query">
	SELECT
		<cfloop list="#a_str_display_columns#" index="a_str_column">
		
			<cfif StructKeyExists(arguments.fieldtypeinformation, a_str_column)>
				
				<cfswitch expression="#arguments.fieldtypeinformation[a_str_column]#">
					<cfcase value="varchar">
					CAST(#a_str_column# AS VARCHAR) AS #a_str_column#
					</cfcase>
					<cfcase value="TIMESTAMP">
					CAST(#a_str_column# AS TIMESTAMP) AS #a_str_column#
					</cfcase>
					<cfcase value="INTEGER">
					CAST(#a_str_column# AS INTEGER) AS #a_str_column#
					</cfcase>					
					<cfdefaultcase>
						#a_str_column#
					</cfdefaultcase>
				</cfswitch>
				
			<cfelse>
				#a_str_column#
			</cfif>
		
			<cfif ListLast(a_str_display_columns) NEQ a_str_column>,</cfif>
		
		</cfloop>
		
	FROM
		arguments.query
	<cfif Len(arguments.orderby) GT 110>
	ORDER BY
		#arguments.orderby#
	</cfif>
	;
	</cfquery>
	

</cfif>

<cfset a_struct_db_fieldnames = StructNew()>

<cfif arguments.fieldnameinformation.recordcount GT 0>
	<cfloop query="arguments.fieldnameinformation">
		<cfset a_struct_db_fieldnames['db_' & arguments.fieldnameinformation.fieldname] = arguments.fieldnameinformation.showname>
	</cfloop>
</cfif>

<cfset a_struct_db_fieldnames.b_telephone = 'Telefon'>
<cfset a_struct_db_fieldnames.b_city = 'Stadt'>
<cfset a_struct_db_fieldnames.company = 'Firma'>
<cfset a_struct_db_fieldnames.dt_lastcontact = 'Letzter Kontakt'>
<cfset a_struct_db_fieldnames.surname = 'Nachname'>
<cfset a_struct_db_fieldnames.firstname = 'Vorname'>
<cfset a_struct_db_fieldnames.department = 'Abteilung'>
<cfset a_struct_db_fieldnames.email_prim = 'E-Mail'>