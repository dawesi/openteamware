<!--- //

	Component:	SQL
	Description:Execute generic SQL operations




	TODO hp: implement security check in here as well ...

// --->

<cfcomponent output="false">

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">

	<cffunction access="public" name="InsertUpdateRecord" output="false" returntype="struct"
			hint="create a new record in a table">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="false" default=""
			hint="if the servicekey is given, check the security permissions as well ...">
		<cfargument name="action" type="string" required="true"
			hint="INSERT or UPDATE">
		<cfargument name="table" type="string" required="true"
			hint="name of the table">
		<cfargument name="primary_field" type="string" required="true"
			hint="name of the primary field ... needed especially for UPDATES (entrykey)">
		<cfargument name="data" type="struct" required="true"
			hint="structure holding data to insert ... key = database field name">

		<cfset var stReturn = GenerateReturnStruct() />

		<!--- analyze and check table ... --->
		<cfset var a_struct_analyze_table = AnalyzeTableStructure(table = arguments.table) />
		<cfset var a_arr_fields = 0 />
		<cfset var a_struct_match_data = 0 />
		<cfset var a_arr_data = 0 />
		<cfset var sEntrykey = '' />
		<!--- primary index field, = entrykey --->
		<cfset var a_bol_primary_field_found = false />
		<cfset var a_str_primary_field_value = '' />
		<cfset var ii = 0 />

		<cfif NOT a_struct_analyze_table.result>
			<cfreturn a_struct_analyze_table />
		</cfif>

		<!--- only allow a-z 0-9 table names ... --->
		<cfset arguments.table = ReturnStringWithOnly_AZ09(arguments.table) />
		<cfset arguments.database = 'mycrm' />

		<!--- get fields ... --->
		<cfset a_arr_fields = a_struct_analyze_table.fields />

		<!--- match fields with given data ... --->
		<cfset a_struct_match_data = MatchDataAndFields(securitycontext = arguments.securitycontext,
											usersettings = arguments.usersettings,
											data = arguments.data,
											fields = a_struct_analyze_table.fields,
											fieldlist = a_struct_analyze_table.fieldlist,
											action = arguments.action) />


		<cfif NOT a_struct_match_data.result>
			<cfreturn a_struct_match_data />
		</cfif>

		<!--- for debugging purposes ... --->
		<cfset stReturn.data = a_struct_match_data />

		<cfset a_arr_data = a_struct_match_data.a_arr_real_data />

		<!--- check if the primary field is given ... ONLY in UPDATE mode --->
		<cfif arguments.action IS 'UPDATE'>

			<cfloop from="1" to="#ArrayLen(a_arr_data)#" index="ii">
				<cfif a_arr_data[ii].fieldname IS arguments.primary_field>
					<cfset a_bol_primary_field_found = true />
					<cfset a_str_primary_field_value = a_arr_data[ii].data />
				</cfif>
			</cfloop>

			<!--- not found ... --->
			<cfif NOT a_bol_primary_field_found>
				<cfreturn SetReturnStructErrorCode(stReturn, 5400) />
			</cfif>

		</cfif>

		<!--- Call now INSERT or UPDATE? ... --->
		<cfif arguments.action IS 'INSERT'>
			<cfinclude template="sql/inc_sql_insert.cfm">
		<cfelse>
			<cfinclude template="sql/inc_sql_update.cfm">
		</cfif>

		<!--- return the entrykey of the new record ... --->
		<cfset stReturn.entrykey = sEntrykey />

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<cffunction access="public" name="MatchDataAndFields" output="false" returntype="struct"
			hint="match the given fields plus the fields ... return fields with data only">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="data" type="struct" required="true"
			hint="data provided by the user">
		<cfargument name="fields" type="array" required="true"
			hint="array holding fields information">
		<cfargument name="fieldlist" type="string" required="true"
			hint="list of fields ...">
		<cfargument name="action" type="string" required="true"
			hint="INSERT or UPDATE">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_arr_real_data = ArrayNew(1) />
		<cfset var a_str_data = '' />
		<cfset var a_bol_provided = false />

		<cfinclude template="sql/inc_match_data_fields.cfm">

		<cfset stReturn.a_arr_real_data = a_arr_real_data />

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<cffunction access="public" name="DeleteRecord" output="false" returntype="struct">
	</cffunction>

	<cffunction access="public" name="AnalyzeTableStructure" output="false" returntype="struct"
			hint="Analyze a certain table and store field information">
		<cfargument name="table" type="string" required="true"
			hint="name of the table">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_structure = 0 />
		<cfset var a_arr_fields = ArrayNew(1) />

		<!--- only allow a-z 0-9 table names ... --->
		<cfset arguments.table = ReturnStringWithOnly_AZ09(arguments.table) />
		<cfset arguments.database = 'mycrm' />

		<cfif Len(arguments.table) IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 5400) />
		</cfif>

		<cftry>
		<cfinclude template="sql/inc_analyze_table.cfm">
		<cfcatch type="any">
			<cfset stReturn.exception = cfcatch />
			<cfreturn SetReturnStructErrorCode(stReturn, 5400) />
		</cfcatch>
		</cftry>

		<!--- return the fields plus a list of fields ... --->
		<cfset stReturn.fields = a_arr_fields />
		<cfset stReturn.fieldlist = ValueList(stReturn.q_select_raw_structure.field) />

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

</cfcomponent>

