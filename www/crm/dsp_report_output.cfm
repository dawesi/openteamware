<cfparam name="url.entrykey" type="string">

<!--- select output file ... --->
<cfquery name="q_select_output">
SELECT
	wddx,reportkey,includefields,dt_created
FROM
	crm_reports_output
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfwddx action="wddx2cfml" input="#q_select_output.wddx#" output="stReturn">


<cfinvoke component="/components/crmsales/crm_reports" method="GetReportSettings" returnvariable="a_struct_report">
	<cfinvokeargument name="entrykey" value="#q_select_output.reportkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<h2><cfoutput>#a_struct_report.q_select_report.reportname#</cfoutput></h2>
Aktive Filter: <cfoutput>#a_struct_report.q_select_report.crmfilterkey#</cfoutput>
<br>


<cfif Len(stReturn.tablekey_of_report_output) GT 0>
	<cflocation addtoken="no" url="../database/index.cfm?action=ViewTable&table_entrykey=#stReturn.tablekey_of_report_output#">
</cfif>


<cfswitch expression="#q_select_output.reportkey#">

	<cfcase value="ECC429C2-E237-F73F-E6233C1656C80378">
		<!--- shares by country --->
		<cfinclude template="report_output/inc_output_ECC429C2-E237-F73F-E6233C1656C80378.cfm">
	</cfcase>

	<cfcase value="EC8529E6-F963-096F-4EAE7C2041262B44">
		<!--- inactive accounts --->
		<cfinclude template="report_output/inc_output_EC8529E6-F963-096F-4EAE7C2041262B44.cfm">
	</cfcase>
	<cfdefaultcase>
	
	</cfdefaultcase>
</cfswitch>