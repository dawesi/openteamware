<!--- //

	Component:	Lang
	Function:	ReadTranslationsFromCSV
	Description:Read translation and insert into database
	

// --->

<cffile action="read" charset="utf-8" file="#sFilename#" variable="as">

<!--- read CSV --->
<cfset q_csv = application.components.cmp_tools.CSVToQueryEx(csv = as) />

<!--- <cfquery name="q_select_top_csv" dbtype="query" maxrows="10">
SELECT
	*
FROM
	q_csv
;
</cfquery>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="tras" type="html">
<cfdump var="#q_select_top_csv#">
</cfmail> --->

<!--- all columns ... --->
<cfset a_str_columns = q_csv.columnlist />

<!--- first column is entryid, so subtract one ... --->
<cfset a_int_langs = ListLen(a_str_columns) - 1 />

<!--- generate list of columns / corresponding CSV query column ... --->
<cfset a_struct_langs = StructNew()>

<cfloop from="1" to="#a_int_langs#" index="ii">
	<cfset a_struct_langs[ii] = 'column_' & (ii + 1) />
</cfloop>

<!--- loop over query ... --->
<cfloop query="q_csv">
	
	<!--- if not an empty item, insert into translation data ... --->
	<cfset a_str_entryname = Trim(q_csv['column_1'][q_csv.currentrow])>
		
	<cfloop from="1" to="#a_int_langs#" index="ii">
		
		<cfset a_str_value = q_csv[a_struct_langs[ii]][q_csv.currentrow]>
		
		<cfif Len(a_str_value) GT 0>
			
			<cfquery name="q_insert">
			INSERT INTO
				langdata
				(
				entryid,
				langno,
				entryvalue
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_entryname#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#(ii - 1)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_value#">
				)
			;
			</cfquery>
			
		</cfif>
		
	</cfloop>
		
</cfloop>
	


