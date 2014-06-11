<!--- //

	Module:        Import
	Description:   Reader component for xls files
	

	
	// --->
<cfcomponent name="cmp_read_xls" hint="Read and parse an xls file">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction name="ParseData" output="false" returntype="struct"
			hint="Parse an xls file">
		<cfargument name="filename" type="string" required="true"
			hint="location of file to parse">
		<cfargument name="maxrows" type="numeric" required="false" default="0"
			hint="number of max records to return ... 0 = return all">
		
		<cfset var stReturn = GenerateReturnStruct() />
		
		<cftry>
			
			<cfspreadsheet	headerrow="1"
							action="read"
							src="#arguments.filename#"
							query="q_select_data">
			</cfspreadsheet>
						  
			<cfif arguments.maxrows GT 0>
				<cfquery name="q_select_data" dbtype="query" maxrows="#arguments.maxrows#">
				SELECT
					*
				FROM
					q_select_data
				;
				</cfquery>
			</cfif>
			
			<cfset stReturn.q_select_data = q_select_data />
			
			<cfcatch type = "any">
				
				<cfset application.components.cmp_log.LogException(error = cfcatch, session = session, args = arguments, message = cfcatch.Message, url = url) />
				<cflog text="There was a problem reading XLS file: '#arguments.filename#'." type="warning" log="Application" file="ibx_import_excel_error_log">
				
				<cfreturn SetReturnStructErrorCode(stReturn, 12501, cfcatch.Message) />
			</cfcatch>
		</cftry>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

</cfcomponent>